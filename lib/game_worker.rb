require 'json'
require 'bunny'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/ship_builder'

class GameWorker

  attr_accessor :ch, :games

  def initialize(ch)
    @ch    = ch
    @games = {}
  end

  def start_rpc(queue_name)
    q = ch.queue(queue_name)
    x = ch.default_exchange

    q.subscribe(block: true) do |delivery_info, properties, payload|

      payload_hash = JSON.parse(payload, symbolize_names: true)
      response     = nil

      response = if payload_hash[:command] == 'play'
                   process_play_command(payload_hash)
                 elsif payload_hash[:command] == 'place'
                   process_place_command(payload_hash)
                 elsif payload_hash[:command] == 'ready'
                   process_ready_command(payload_hash)
                 else
                   'INVALID'
                 end

      x.publish(response.to_s, routing_key: properties.reply_to, correlation_id: properties.correlation_id)
    end
  end

  def start_topic
    q = ch.queue('', exclusive: true)
    x = ch.topic('game_updates')

    bind_all_active_games(q, x)

    q.subscribe(block: true) do |delivery_info, properties, body|
      puts " [x] #{delivery_info.routing_key}:#{body}"
      game_id = delivery_info.routing_key
      process_shot(game_id, body, x)
      bind_all_active_games(q, x)
    end
  end

  def process_shot(game_id, body, x)
    game            = game_worker.games[game_id]
    targeted_player = game.players[body[:target]]
    shot_position   = {x: body[:x], y: body[:y]}

    if targeted_player.shot_hit?(shot_position)
      game.switch_turns
      body[:next_turn] = game.current_turn
      body[:result]    = 'hit'
      targeted_player.process_hit(shot_position)
    else
      game.switch_turns
      body[:next_turn] = game.current_turn
      body[:result]    = 'miss'
      targeted_player.misses_against << shot_position
    end

    emit_game_update(game_id, body, x)
  end

  def emit_game_update(game_id, body, x)
    game_update = build_game_update_hash(body)
    x.publish(game_update, routing_key: "games.#{game_id}")
  end

  def build_game_update_hash(body)
    return {
      attacker:  body[:name],
      target:    body[:target],
      result:    body[:result],
      next_turn: body[:next_turn]
    }
  end

  def bind_all_active_games(q, x)
    games.each do |game|
      q.bind(x, routing_key: game.id)
    end
  end

  def process_play_command(payload_hash)
    game    = fetch_game || create_new_game
    name    = payload_hash[:payload][:name]
    player  = Player.new(name: name)
    @games[game.id].players[name] = player
    puts "#{name} joined game #{game.id}"

    return {game_id: game.id}
  end

  def process_place_command(payload_hash)
    name         = payload_hash[:payload][:name]
    game_id      = payload_hash[:payload][:game_id]
    current_game = @games.fetch(game_id)
    current_game.players[name].ships << place_ship(payload_hash[:payload])
    puts "#{name} placed #{payload_hash[:payload][:type]} on #{current_game.inspect}"

    return {game_id: game_id}
  end

  def process_ready_command(payload_hash)
  end

  def fetch_game
    @games.each do |game_id, game|
      if game.players.length == 1
        return game
      end
    end
    return false
  end

  def create_new_game
    new_game    = Game.new
    new_game.id = generate_uuid
    @games[new_game.id] = new_game
    return new_game
  end

  def generate_uuid
    "#{rand}#{rand}"
  end

  def place_ship(payload)
    return ShipBuilder.new(payload).ship
  end

end
