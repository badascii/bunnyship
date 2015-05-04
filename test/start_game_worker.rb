require 'bunny'
# require_relative '../lib/game'
# require_relative '../lib/player'
require_relative '../lib/game_rpc_worker'

conn = Bunny.new(automatically_recover: false)
conn.start

ch = conn.create_channel

begin
  game_rpc_worker = GameRPCWorker.new(ch)
  puts " [x] Awaiting Player requests."
  game_rpc_worker.start('setup_queue')
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

  # game_rpc_worker.process_place_command(payload_hash)
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end
