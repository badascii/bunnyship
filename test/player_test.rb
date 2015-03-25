require 'minitest/autorun'
require 'minitest/spec'
require 'yaml'
require_relative '../lib/player'
require_relative '../lib/ship'

class PlayerTest < MiniTest::Test

  def setup
    @player = Player.new
  end

  def test_get_position_status
    opts     = {type: 'destroyer', positions: [{x: 1, y: 1}, {x: 1, y: 2}], damage: [{x: 1, y: 1}]}
    ship     = Ship.new(opts)

    @player.ships << ship
    @player.misses_against << {x: 3, y: 3}

    assert_equal 'hit', @player.get_position_status(x: 1, y: 1)
    assert_equal 'miss', @player.get_position_status(x: 3, y: 3)
    assert_equal 'destroyer', @player.get_position_status(x: 1, y: 2)
    assert_equal 'empty', @player.get_position_status(x: 4, y: 1)
  end

  def test_battleship_status
    opts = {type: 'battleship', positions: [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}, {x: 5, y: 1}]}
    ship = Ship.new(opts)

    @player.ships << ship

    assert_equal 'battleship', @player.get_position_status({x: 1, y: 1})
    assert_equal 'battleship', @player.get_position_status({x: 2, y: 1})
    assert_equal 'battleship', @player.get_position_status({x: 3, y: 1})
    assert_equal 'battleship', @player.get_position_status({x: 4, y: 1})
    assert_equal 'battleship', @player.get_position_status({x: 5, y: 1})
  end

  def test_shot_hit
    assert_equal false, @player.shot_hit?(x: 1, y: 1)

    opts = {type: 'battleship', positions: [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}, {x: 5, y: 1}]}
    ship = Ship.new(opts)
    @player.ships << ship

    assert_equal true, @player.shot_hit?(x: 1, y: 1)
  end

  def test_process_hit
    opts     = {type: 'destroyer', positions: [{x: 1, y: 1}, {x: 1, y: 2}], damage: [{x: 1, y: 1}]}
    ship     = Ship.new(opts)

    @player.ships << ship

    @player.process_hit(x: 1, y: 1)

    assert_equal true, @player.ships[0].damage.include?(x: 1, y: 1)
  end

end
