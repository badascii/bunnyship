require 'bunny'
require_relative '../lib/player_rpc_worker'
require_relative '../lib/player_topic_worker'

print ARGV

conn = Bunny.new(automatically_recover: false)

conn.start

rpc_ch              = conn.create_channel
topic_ch            = conn.create_channel
player_rpc_worker   = PlayerRPCWorker.new(rpc_ch, 'setup_queue')
player_topic_worker = PlayerTopicWorker.new(topic_ch)

input_hash = {}
response   = ''

response = if ARGV[0] == 'play'
             input      = ['play', 'Bob']
             input_hash = player_rpc_worker.build_play_input_hash(input)
             player_rpc_worker.rpc_call(input_hash)
           elsif ARGV[0] == 'place'
             input      = ['place', 'battleship', '1', '1', 'v', 'Bob', ARGV[1]]
             input_hash = player_rpc_worker.build_placement_input_hash(input)
             player_rpc_worker.rpc_call(input_hash)
           elsif ARGV[0] == 'ready'
             input      = ['ready', 'Bob', ARGV[1]]
             input_hash = player_rpc_worker.build_ready_input_hash(input)
             player_rpc_worker.rpc_call(input_hash)
           end

puts " [x] Sent input"

if ARGV[0] == 'fire'
  input_hash = {
    target:  'Jimmy',
    name:    'Bob',
    x:       1,
    y:       1,
    game_id: ARGV[1]
  }

  response = player_topic_worker.emit_shot(input_hash)
end

puts " [.] Got #{response}"

rpc_ch.close
topic_ch.close
conn.close
