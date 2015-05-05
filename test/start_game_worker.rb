require 'bunny'
# require_relative '../lib/game'
# require_relative '../lib/player'
require_relative '../lib/game_worker'

conn = Bunny.new(automatically_recover: false)
conn.start
ch   = conn.create_channel

begin
  game_worker = GameWorker.new(ch)

  puts " [x] Awaiting Player requests."

  game_worker.start_rpc('setup_queue')
  game_worker.start_topic

  # game = Game.new
  # player = Player.new
  # game.players[player.name] = player
  # game.id = '1'
  # game_rpc_worker.games[game.id] = game
  # payload_hash =  {
  #     command:   'place',
  #     payload: {
  #       type:      'battleship',
  #       x:         1,
  #       y:         1,
  #       alignment: 'h',
  #       name:      'Jimmy',
  #       game_id:   '1'
  #     }
  #   }
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end
