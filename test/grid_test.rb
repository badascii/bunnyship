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

  def test_positions
    expected_positions = [{ x: 1, y: 1 }, { x: 2, y: 1 },
                          { x: 1, y: 2 }, { x: 2, y: 2 }]
    actual_positions   = []
    @grid_2x2.positions do |position|
      actual_positions << position
    end

    assert_equal expected_positions, actual_positions
  end

  def test_row
    assert_equal [1, 2], @grid_2x2.row
  end

  def test_column
    assert_equal [1, 2], @grid_2x2.column
  end

end
