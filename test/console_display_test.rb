require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/console_display'
require_relative '../lib/player'
require_relative '../lib/grid'
require_relative '../lib/ship'
require_relative '../lib/ship_builder'

class ConsoleDisplayTest < MiniTest::Test

  def setup
    @console_display        = ConsoleDisplay.new
    @player                 = Player.new
    @console_display.player = @player
    grid_2x2                = Grid.new(width: 2, height: 2)
    @game_2x2               = Game.new(grid: grid_2x2)
    grid_5x5                = Grid.new(width: 5, height: 5)
    @game_5x5               = Game.new(grid: grid_5x5)
  end

  def test_place_ship
    assert_equal 0, @player.ships.length

    input_hash = {
      type:      'battleship',
      x:         1,
      y:         1,
      alignment: 'h',
      length:    4
    }

    @console_display.place_ship(input_hash)

    assert_equal 1, @player.ships.length
  end

  def test_build_input_hash
    expected_hash = {
      type:      'battleship',
      x:         1,
      y:         1,
      alignment: 'h'
    }
    input = ['place', 'battleship', '1', '1', 'h']

    assert_equal expected_hash, @console_display.build_input_hash(input)
  end

end
