require 'bunny'
require_relative '../lib/player_worker'

print ARGV

conn = Bunny.new(automatically_recover: false)

conn.start

ch     = conn.create_channel
player = PlayerWorker.new(ch, 'rpc_queue')
input_hash = {}

if ARGV[0] == 'play'
  input_hash = player.build_play_input_hash(ARGV)
elsif ARGV[0] == 'place'
  input_hash = player.build_placement_input_hash(ARGV)
elsif ARGV[0] == 'ready'
  input_hash = player.build_ready_input_hash(ARGV)
end

puts " [x] Sent input"

response = player.call(input_hash)

puts " [.] Got #{response}"

ch.close
conn.close
