require 'minitest/autorun'
require 'minitest/spec'
require 'yaml'
require_relative '../lib/ship_builder'

class ShipBuilderTest < MiniTest::Test

  def setup
    ship_opts  = {type: 'battleship', x: 1, y: 1, alignment: 'h', length: 4}
    @ship_builder = ShipBuilder.new(ship_opts)
  end

  def test_ship_builder_output
    opts          = {type: 'battleship', positions: [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}]}
    expected_ship = Ship.new(opts)
    assert_equal expected_ship, @ship_builder.ship
  end

end
