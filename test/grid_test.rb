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

end
