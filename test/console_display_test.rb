require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/console_display'
# require_relative '../lib/player'
require_relative '../lib/grid'

class ConsoleDisplayTest < MiniTest::Test

  def setup
    @grid_2x2        = Grid.new(width: 2, height: 2)
    @grid_5x5        = Grid.new(width: 5, height: 5)
    @default_grid    = Grid.new
    @console_display = ConsoleDisplay.new(@default_grid)
  end

  def test_build_x_legend
    expected_legend = "12345678910\n"

    assert_equal expected_legend, @default_grid.build_x_legend
  end

  def test_build_2x2_output
    expected_string = ""

    2.times { |y| expected_string += "#{y + 1}~~\n" }

    assert_equal expected_string, @console_display.build_all_rows
  end

  def test_build_10x10_output
    expected_string = ""

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    assert_equal expected_string, @console_display.build_all_rows
  end

  def test_build_complete_grid
    expected_string = "12345678910\n"

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    assert_equal expected_string, @console_display.build_complete_grid
  end

  # def test_get_status
  #   hit   = '*'
  #   miss  = '!'
  #   ship  = 'S'
  #   empty = '~'

  #   player = Player.new

  #   player.ships[0].damage << {x:1, y: 1}
  #   player.misses_against << {x: 2, y: 1}

  #   assert_equal hit, @console_display.get_status(x: 1, y: 1)
  #   assert_equal miss, @console_display.get_status(x: 2, y: 1)
  #   assert_equal ship, @console_display.get_status(x: 3, y: 1)
  #   assert_equal empty, @console_display.get_status(x: 4, y: 1)
  # end

end
