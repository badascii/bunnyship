require 'minitest/autorun'
require 'minitest/spec'
require 'yaml'
require_relative '../lib/console_display'
require_relative '../lib/player'
require_relative '../lib/grid'
require_relative '../lib/ship'

class ConsoleDisplayTest < MiniTest::Test

  def setup
    ship_opts        = {type: 'destroyer', positions: [{x: 1, y: 1}, {x: 1, y: 2}]}
    @ship            = [Ship.new(ship_opts)]
    player_opts      = {ships: @ship}
    @player          = Player.new(player_opts)
    @grid_2x2        = Grid.new(width: 2, height: 2)
    @grid_5x5        = Grid.new(width: 5, height: 5)
    @default_grid    = Grid.new
    console_opts     = {grid: @default_grid, player: @player}
    @console_display = ConsoleDisplay.new(console_opts)
    console_opts     = {grid: @default_grid, player: @player}
    empty_opts       = {grid: @default_grid, player: Player.new}
    @empty_display   = ConsoleDisplay.new(empty_opts)
  end

  def test_build_x_legend
    expected_legend = "12345678910\n"

    assert_equal expected_legend, @console_display.build_x_legend
  end

  def test_build_2x2_output
    console_opts    = {grid: @grid_2x2, player: @player}
    console_2x2     = ConsoleDisplay.new(console_opts)
    expected_string = "1S~\n2S~\n"

    assert_equal expected_string, console_2x2.build_all_rows
  end

  def test_build_10x10_output
    expected_string = ""

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    assert_equal expected_string, @empty_display.build_all_rows
  end

  def test_build_complete_grid
    expected_string = "12345678910\n"

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    assert_equal expected_string, @empty_display.build_complete_grid
  end

  def test_get_status
    hit   = '*'
    miss  = '!'
    ship  = 'S'
    empty = '~'

    @player.ships.first.damage << {x:1, y: 1}
    @player.misses_against << {x: 3, y: 3}

    assert_equal hit, @console_display.get_status(x: 1, y: 1)
    assert_equal miss, @console_display.get_status(x: 3, y: 3)
    assert_equal ship, @console_display.get_status(x: 1, y: 2)
    assert_equal empty, @console_display.get_status(x: 4, y: 1)
  end

end
