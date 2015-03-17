require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/validator'
require_relative '../lib/display'
require_relative '../lib/player'
require_relative '../lib/grid'
require_relative '../lib/ship'
require_relative '../lib/game'

class ValidatorTest < MiniTest::Test

  def setup
    opts        = {type: 'battleship', positions: [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}]}
    player_ship        = Ship.new(opts)
    player      = Player.new
    player.ships << player_ship
    @game       = Game.new
    @game.players << player
    game_ship   = { 'battleship' => 4 }
    @game.ships = game_ship
    @validator  = Validator.new(@game)
  end

  def test_game_settings
    assert_equal 1, @validator.game.ships.length
    assert_equal 1, @validator.game.players.length
  end

  def test_validate_type
    assert_equal true,  @validator.valid_type?('battleship')
    assert_equal false, @validator.valid_type?('sub')
  end

  def test_x_exists
    assert_equal true, @validator.x_exists?(1)
    assert_equal false, @validator.x_exists?(11)
    assert_equal false, @validator.x_exists?(-1)
  end

  def test_y_exists
    assert_equal true, @validator.y_exists?(1)
    assert_equal false, @validator.y_exists?(11)
    assert_equal false, @validator.y_exists?(-1)
  end

  def test_valid_width?
    ship_length = @game.players[0].ships.first.size
    x           = 4
    invalid_x   = 8
    assert_equal true, @validator.valid_width?(x, ship_length)
    assert_equal false, @validator.valid_width?(invalid_x, ship_length)
  end

  def test_valid_height?
    ship_length = @game.players[0].ships.first.size
    y           = 4
    invalid_y   = 8
    assert_equal true, @validator.valid_height?(y, ship_length)
    assert_equal false, @validator.valid_height?(invalid_y, ship_length)
  end

end
