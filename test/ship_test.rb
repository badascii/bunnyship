require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/ship'

class ShipTest < MiniTest::Test
  def setup
    opts = {
      type:      'cruiser',
      positions: [{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}],
      damage:    [{x: 1, y: 1}]
    }
    @ship = Ship.new(opts)
  end

  def test_size
    assert_equal(3, @ship.size)
  end

  def test_shot_hit
    hit  = {x: 1, y: 1}
    miss = {x: 2, y: 1}

    assert_equal(true, @ship.shot_hit?(hit))
    assert_equal(false, @ship.shot_hit?(miss))
  end

  def test_damage_ordered_destroyed
    assert_equal(false, @ship.destroyed?)

    @ship.damage = [{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}]

    assert_equal(true, @ship.destroyed?)
  end

  def test_in_sequence
    opts = {
      type:      'cruiser',
      positions: [{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}],
      damage:    [{x: 1, y: 1}]
    }
    unordered_ship = Ship.new(opts)

    assert_equal(false, unordered_ship.in_sequence?)
    assert_equal(true, @ship.in_sequence?)
  end

  def test_neighboring_positions
    pos_1 = 1
    pos_2 = 2
    pos_3 = 5

    assert_equal(true, @ship.neighboring_positions?(pos_1, pos_2))
    assert_equal(false, @ship.neighboring_positions?(pos_1, pos_3))
  end

end
