require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/grid'

class GridTest < MiniTest::Test

  def setup
    opts = { width: 5, height: 5 }
    @grid = Grid.new(opts)
    @default_grid = Grid.new
  end

  def test_height
    assert_equal 5, @grid.height
  end

  def test_height_default
    assert_equal 10, @default_grid.height
  end

  def test_width
    assert_equal 5, @grid.width
  end

  def test_width_default
    assert_equal 10, @default_grid.width
  end

  def test_build_positions
    grid = Grid.new(width: 2, height: 2)
    positions = [{ x: 1, y: 1, status: '~' },
                 { x: 2, y: 1, status: '~' },
                 { x: 1, y: 2, status: '~' },
                 { x: 2, y: 2, status: '~' }]

    assert_equal positions, grid.build_positions
  end

end
