require 'minitest/autorun'
require 'minitest/spec'
require 'bunny'
require_relative '../lib/player_rpc_worker'

class PlayerWorkerTest < MiniTest::Test

  def setup
    conn           = Bunny.new(automatically_recover: false)
    conn.start
    ch             = conn.create_channel
    @player_worker = PlayerRPCWorker.new(ch, 'rpc_queue')
  end

  def test_generate_uuid
    new_uuid = @player_worker.generate_uuid

    assert_equal String, new_uuid.class
  end

  def test_build_play_input_hash
    input = ['play', 'Jimmy']

    expected_hash = {
      command: 'play',
      payload: {
        name: 'Jimmy'
      }
    }

    input_hash = @player_worker.build_play_input_hash(input)

    assert_equal expected_hash, input_hash
  end

  def test_build_placement_input_hash
    input         = ['place', 'battleship', '1', '1', 'h', 'Jimmy', '1']
    expected_hash = {
      command: 'place',
      payload: {
        type:      'battleship',
        x:         1,
        y:         1,
        alignment: 'h',
        name:      'Jimmy',
        game_id:   '1'
      }
    }

    input_hash = @player_worker.build_placement_input_hash(input)

    assert_equal expected_hash, input_hash
  end

  # def test_build_ready_input_hash(input)
  #   input = ['play', 'Jimmy']

  #   expected_hash = {
  #     command: 'play',
  #     payload: {
  #       name: 'Jimmy'
  #     }
  #   }

  #   input_hash = @player_worker.build_ready_input_hash(input)

  #   assert_equal expected_hash, input_hash


  #   return {
  #     command: input[0]
  #   }
  # end

end
