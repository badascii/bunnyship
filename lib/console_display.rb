require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/validator'
require_relative '../lib/ship_builder'

class ConsoleDisplay < Display

  ICON_MAPPING = {
    'empty'      => '~',
    'miss'       => '!',
    'hit'        => '*',
    'carrier'    => 'A',
    'battleship' => 'B',
    'cruiser'    => 'C',
    'destroyer'  => 'D',
    'submarine'  => 'S'
  }

  attr_accessor :game, :player

  def initialize(opts={})
    @game   = opts[:game]   || Game.new
    @player = opts[:player] || Player.new
  end

  def run
    puts "Place a ship using this command:\nplace ship_name x y h/v\n"

    until all_ships_placed?
      input      = gets.downcase.split(/\W+/)
      input_hash = build_input_hash(input)
      validator  = Validator.new(game)

      if validator.valid_ship?(input_hash)
        input_hash[:length] = game.ships[input_hash[:type]]
        place_ship(input_hash)
        grid = build_all_rows
        puts grid
      else
        puts 'Invalid input. Please try again.'
      end
    end
    game.players[player.name] = player
  end

  def place_ship(input_hash)
    ship_builder = ShipBuilder.new(input_hash)
    ship         = ship_builder.ship
    player.ships << ship
  end

  def build_input_hash(input)
    input_hash = {
      type:      input[1],
      x:         input[2].to_i,
      y:         input[3].to_i,
      alignment: input[4]
    }

    return input_hash
  end

end
