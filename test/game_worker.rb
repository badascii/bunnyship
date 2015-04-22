require 'json'
require 'bunny'
require_relative '../lib/game'
require_relative '../lib/player'

class GameWorker

  def initialize(ch)
    @ch = ch
    @games = {}
  end

  def start(queue_name)
    @q = @ch.queue(queue_name)
    @x = @ch.default_exchange

    @q.subscribe(block: true) do |delivery_info, properties, payload|

      payload_hash = JSON.parse(payload)
      command      = get_command(payload_hash)

      if payload_hash['command'] == 'play'
        game    = fetch_game || create_new_game
        name    = payload_hash['payload']['name']
        player  = Player.new(name: name)
        @games[game.id].players[name] = player
        puts game.players
      elsif payload_hash['command'] == 'place'
        name         = payload_hash['payload']['name']
        game_id      = payload_hash['payload']['game_id']
        current_game = @games.fetch(game_id)
        current_game[name].ships << place_ship(payload_hash['payload'])
        puts current_game[name].ships
      elsif payload_hash['command'] == 'ready'
        player_ready(payload_hash)
      else
        # invalid_command(payload_hash)
      end

      @x.publish(command, routing_key: properties.reply_to, correlation_id: properties.correlation_id)
    end
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
    payload['length'] = 4
    return ShipBuilder.new(payload).ship
  end

  def player_ready(payload_hash)

  end

  def invalid_command(payload_hash)

  end

  def get_command(payload_hash)
    if payload_hash['command'] == 'play'
      return 'play'
    elsif payload_hash['command'] == 'place'
      return 'place'
    elsif payload_hash['command'] == 'ready'
      return 'ready'
    else
      return 'invalid'
    end
  end

end

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel

begin
  server = GameWorker.new(ch)
  puts " [x] Awaiting RPC requests"
  server.start('rpc_queue')
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end