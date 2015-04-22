require 'bunny'
require 'json'
require_relative '../lib/player'

class PlayerWorker
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition

  def initialize(ch, server_queue)
    @ch           = ch
    @x            = ch.default_exchange

    @server_queue = server_queue
    @reply_queue  = ch.queue('', exclusive: true)

    @lock         = Mutex.new
    @condition    = ConditionVariable.new

    @reply_queue.subscribe do |delivery_info, properties, payload|
      if properties[:correlation_id] == self.call_id
        self.response = payload
        self.lock.synchronize{self.condition.signal}
      end
    end
  end

  def call(input_hash)
    self.call_id = self.generate_uuid
    json = input_hash.to_json

    @x.publish(json,
               routing_key:    @server_queue,
               correlation_id: call_id,
               reply_to:       @reply_queue.name)

    lock.synchronize{condition.wait(lock)}
    response
  end

  def generate_uuid
    "#{rand}#{rand}#{rand}"
  end

  def build_play_input_hash(input)
    return {
      command: input[0],
      payload: {
        name: input[1]
      }
    }
  end

  def build_placement_input_hash(input)
    return {
      command:   input[0],
      payload: {
        type:      input[1],
        x:         input[2].to_i,
        y:         input[3].to_i,
        alignment: input[4]
      }
    }
  end

  def build_ready_input_hash(input)
    return {
      command: input[0]
    }
  end
end

print ARGV

conn   = Bunny.new(automatically_recover: false)

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