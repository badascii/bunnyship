require 'json'
require 'bunny'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/ship_builder'

class GameWorker

  attr_accessor :games

  def initialize(ch)
    @ch    = ch
    @games = {}
  end

  def start(queue_name)
    @q = @ch.queue(queue_name)
    @x = @ch.default_exchange

    @q.subscribe(block: true) do |delivery_info, properties, payload|

      payload_hash = JSON.parse(payload, symbolize_names: true)
      response     = nil

      if payload_hash[:command] == 'play'
        response = play_command(payload_hash)
      elsif payload_hash[:command] == 'place'
        response = place_command(payload_hash)
      elsif payload_hash[:command] == 'ready'
        response = ready_command(payload_hash)
      else
        response = 'INVALID'
      end

      @x.publish(response, routing_key: properties.reply_to, correlation_id: properties.correlation_id)
    end
  end

  def play_command(payload_hash)
    game    = fetch_game || create_new_game
    name    = payload_hash[:payload][:name]
    player  = Player.new(name: name)
    @games[game.id].players[name] = player

    return {game_id: game.id}
  end

  def place_command(payload_hash)
    name         = payload_hash[:payload][:name]
    game_id      = payload_hash[:payload][:game_id]
    current_game = @games.fetch(game_id)
    current_game.players[name].ships << place_ship(payload_hash[:payload])

    return {game_id: game_id}
  end

  def ready_command(input_hash)

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
