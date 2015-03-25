require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/ship_builder'

class GameTest < MiniTest::Test

  def setup
    @game   = Game.new
    @player = Player.new
  end

  def test_active_player_count
    assert_equal 0, @game.active_player_count

    @game.players[@player.name] = @player
    ship = ShipBuilder.new(type: 'battleship', x: 1, y: 1, alignment: 'h', length: 4).ship
    @game.players[@player.name].ships << ship

    assert_equal 1, @game.active_player_count
  end

  def test_active
    assert_equal false, @game.active?

    @game.players[@player.name] = @player
    ship = ShipBuilder.new(type: 'battleship', x: 1, y: 1, alignment: 'h', length: 4).ship
    @game.players[@player.name].ships << ship

    assert_equal true, @game.active?
  end

end
