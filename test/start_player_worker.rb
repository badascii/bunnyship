require 'bunny'
require_relative '../lib/player_rpc_worker'
require_relative '../lib/player_topic_worker'

print ARGV

conn = Bunny.new(automatically_recover: false)

conn.start

ch                  = conn.create_channel
player_rpc_worker   = PlayerRPCWorker.new(ch, 'setup_queue')
player_topic_worker = PlayerTopicWorker.new(ch, 'update_queue')

input_hash = {}

if ARGV[0] == 'play'
  input = ['play', 'Jimmy']
  input_hash = player_rpc_worker.build_play_input_hash(input)
elsif ARGV[0] == 'place'
  input = ['place', 'battleship', '1', '1', 'v', 'Jimmy', ARGV[1]]
  input_hash = player_rpc_worker.build_placement_input_hash(input)
elsif ARGV[0] == 'ready'
  input = ['ready', 'Jimmy', ARGV[1]]
  input_hash = player_rpc_worker.build_ready_input_hash(input)
end

puts " [x] Sent input"

response = player_rpc_worker.rpc_call(input_hash)

puts " [.] Got #{response}"

# input_hash = {
#   command: 'fire',
#   payload: {
#     target: 'Jimmy',
#     x:      1,
#     y:      1,
#     name:   'Jimmy',
#     game_id: "#{response}"
#   }
# }

ch.close
conn.close
