require 'bunny'
require_relative '../lib/game_worker'

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
