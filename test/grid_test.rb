require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/grid'

class GridTest < MiniTest::Test

  def setup
    @grid_2x2     = Grid.new(width: 2, height: 2)
    @grid_5x5     = Grid.new(width: 5, height: 5)
    @default_grid = Grid.new
  end

  def test_height
    assert_equal 5, @grid_5x5.height
  end

  def test_height_default
    assert_equal 10, @default_grid.height
  end

  def test_width
    assert_equal 5, @grid_5x5.width
  end

  def test_width_default
    assert_equal 10, @default_grid.width
  end

  def test_build_positions
    positions = [{ x: 1, y: 1, status: '~' },
                 { x: 2, y: 1, status: '~' },
                 { x: 1, y: 2, status: '~' },
                 { x: 2, y: 2, status: '~' }]

    assert_equal positions, @grid_2x2.build_positions
  end

  def test_build_x_legend
    expected_legend = "12345678910\n"

    assert_equal expected_legend, @default_grid.build_x_legend
  end

  def test_build_2x2_output
    expected_string = ""

    2.times { |y| expected_string += "#{y + 1}~~\n" }

    assert_equal expected_string, @grid_2x2.build_rows
  end

  def test_build_10x10_output
    expected_string = ""

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    @default_grid.build_rows
    assert_equal expected_string, @default_grid.build_rows
  end

  def test_build_complete_grid
    expected_string = "12345678910\n"

    10.times { |y| expected_string += "#{y + 1}~~~~~~~~~~\n" }

    puts @default_grid.build_complete_grid
    assert_equal expected_string, @default_grid.build_complete_grid
  end

end
