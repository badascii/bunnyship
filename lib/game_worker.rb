require 'json'
require 'bunny'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/ship_builder'

class GameWorker

  attr_accessor :rpc_ch, :topic_ch, :games

  def initialize(rpc_ch, topic_ch)
    @rpc_ch   = rpc_ch
    @topic_ch = topic_ch
    @games    = {}
  end

  def start_rpc(queue_name)
    q = rpc_ch.queue(queue_name)
    x = rpc_ch.default_exchange

    q.subscribe(block: true) do |delivery_info, properties, payload|

      payload_hash = JSON.parse(payload, symbolize_names: true)
      response     = nil

      response = if payload_hash[:command] == 'play'
                   process_play_command(payload_hash)
                 elsif payload_hash[:command] == 'place'
                   process_place_command(payload_hash)
                 elsif payload_hash[:command] == 'ready'
                   'OK'
                 else
                   'INVALID'
                 end

      x.publish(response.to_s, routing_key: properties.reply_to, correlation_id: properties.correlation_id)

      process_ready_command if payload_hash[:command] == 'ready'
    end
  end

  def start_topic(q, x)
    q.subscribe(block: true) do |delivery_info, properties, body|
      puts " [x] #{delivery_info.routing_key}:#{body}"

      parsed_body = JSON.parse(body, symbolize_names: true)
      game_id     = delivery_info.routing_key

      process_shot(game_id, parsed_body, x)
    end
  end

  def process_shot(game_id, body, x)
    game            = games[game_id]
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

    x.publish(game_update.to_json, routing_key: "games.#{game_id}")
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
    puts 'Binding all games...'
    games.each do |game_id, game|
      q.bind(x, routing_key: game_id)
      puts "Bound #{game_id}"
    end
  end

  def add_player_to_game(game, player)
    @games[game.id].players[player.name] = player
  end

  def process_play_command(payload_hash)
    game    = fetch_game || create_new_game
    name    = payload_hash[:payload][:name]
    player  = Player.new(name: name)

    add_player_to_game(game, player)

    puts "#{name} joined game #{game.id}"

    return {game_id: game.id}
  end

  def process_place_command(payload_hash)
    name         = payload_hash[:payload][:name]
    game_id      = payload_hash[:payload][:game_id]
    puts payload_hash.inspect
    current_game = @games.fetch(game_id)
    current_game.players[name].ships << place_ship(payload_hash[:payload])
    puts "#{name} placed #{payload_hash[:payload][:type]} on #{current_game.inspect}"

    return {game_id: game_id}
  end

  def process_ready_command
    q = topic_ch.queue('')
    x = topic_ch.topic('game_updates')

    bind_all_active_games(q, x)
    start_topic(q, x)
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
    new_game            = Game.new
    new_game.id         = generate_uuid
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
