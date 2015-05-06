require 'json'

class PlayerTopicWorker

  attr_accessor :ch

  def initialize(ch)
    @ch = ch
  end

  def emit_shot(body)
    x = ch.topic('game_updates')

    x.publish(body.to_json, routing_key: body[:game_id])
  end

  def process_game_update(game_id)
    q = ch.queue('')
    x = ch.topic('game_updates')

    q.bind(x, routing_key: game_id)

    q.subscribe(block: true) do |delivery_info, properties, body|
      puts " [x] #{delivery_info.routing_key}:#{body}"
      return body
    end
  end

end
