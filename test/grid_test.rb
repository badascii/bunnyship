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
    expected_string = "~~\n" * 2

    assert_equal expected_string, @grid_2x2.build_output
  end

  def test_build_10x10_output
    expected_string = "~~~~~~~~~~\n" * 10

    assert_equal expected_string, @default_grid.build_output
  end

end
