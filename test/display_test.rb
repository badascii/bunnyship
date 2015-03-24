require 'minitest/autorun'
require 'minitest/spec'
require 'yaml'
require_relative '../lib/display'
require_relative '../lib/player'
require_relative '../lib/grid'
require_relative '../lib/ship'

class DisplayTest < MiniTest::Test

  def setup
    @display  = Display.new
    @player   = Player.new
    grid_2x2  = Grid.new(width: 2, height: 2)
    @game_2x2 = Game.new(grid: grid_2x2)
    grid_5x5  = Grid.new(width: 5, height: 5)
    @game_5x5 = Game.new(grid: grid_5x5)
  end

  def test_build_x_legend
    expected_legend = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    assert_equal expected_legend, @display.build_x_legend
  end

  def test_build_2x2_output
    display_opts    = {game: @game_2x2, player: @player}
    display_2x2     = Display.new(display_opts)
    expected_hash   = {1=>["empty", "empty"], 2=>["empty", "empty"]}

    assert_equal expected_hash, display_2x2.build_all_rows
  end

  def test_build_10x10_output
    expected_hash = {
     1=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     2=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     3=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     4=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     5=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     6=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     7=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     8=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
     9=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"],
    10=>["empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"]}

    assert_equal expected_hash, @display.build_all_rows
  end

end
