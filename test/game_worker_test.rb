require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/game_worker'

class GameWorkerTest < MiniTest::Test

  def setup
    fake_rpc_channel   = 'immachannel'
    fake_topic_channel = 'immanotherchannel'
    @game_worker       = GameWorker.new(fake_rpc_channel, fake_topic_channel)
    @game              = Game.new
    @game.id           = '1'
    @player_1          = Player.new
    @player_2          = Player.new(name: 'Bobby')
    @game_worker.games[@game.id] = @game
  end

  def test_fetch_game
    @game.add(@player_1)

    assert_equal @game, @game_worker.fetch_game

    @game.add(@player_2)

    assert_equal false, @game_worker.fetch_game
  end

  def test_create_new_game
    new_game = @game_worker.create_new_game

    assert_equal String, new_game.id.class
  end

  def test_generate_uuid
    new_uuid = @game_worker.generate_uuid

    assert_equal String, new_uuid.class
  end

  def test_play_command
    payload_hash = {
      command: 'play',
      payload: {
        name: 'Jimmy'
      }
    }

    game_id_hash = @game_worker.process_play_command(payload_hash)

    assert_equal Hash, game_id_hash.class
    assert_equal String, game_id_hash[:game_id].class
  end

  def test_place_command
    @game.add(@player_1)

    payload_hash = {
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

    game_id_hash = @game_worker.process_place_command(payload_hash)

    assert_equal Hash, game_id_hash.class
    assert_equal '1', game_id_hash[:game_id]
  end

  def test_place_ship
    ship_payload = {
      type:      'battleship',
      x:         1,
      y:         1,
      alignment: 'h'
    }

    ship = @game_worker.place_ship(ship_payload)

    assert_equal Ship, ship.class
    assert_equal 'battleship', ship.type
    assert_equal 4, ship.positions.length
    assert_equal true, ship.positions.include?({x: 4, y: 1})
  end

end
