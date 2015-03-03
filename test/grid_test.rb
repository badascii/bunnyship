require 'minitest/autorun'
require 'minitest/spec'
require 'yaml'
require_relative '../lib/grid'

class GridTest < MiniTest::Test

  def setup
    opts = { width: 5, height: 5 }
    @grid = Grid.new(opts)
  end

  def test_height
    assert_equal 5, @grid.height
  end

  def test_height_default
    grid = Grid.new

    assert_equal 10, grid.height
  end

  def test_width
    assert_equal 5, @grid.width
  end

  def test_width_default
    grid = Grid.new

    assert_equal 10, grid.width
  end

  def test_build_positions
    positions = [{ x: 1, y: 1, mark: '~' },
                 { x: 2, y: 1, mark: '~' },
                 { x: 1, y: 2, mark: '~' },
                 { x: 2, y: 2, mark: '~' }
                ]
    grid = Grid.new({ width: 2, height: 2 })

    assert_equal positions, grid.build_positions
  end

end
