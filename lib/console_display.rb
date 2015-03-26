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

  attr_accessor :game, :player, :validator

  def initialize(opts={})
    @game       = opts[:game]   || Game.new
    @player     = opts[:player] || Player.new
    @validator  = Validator.new(game)
  end

  def run
    puts "Place a ship using this command:\nplace ship_name x y h/v\n"

    until all_ships_placed?
      input      = gets.downcase.split(/\W+/)
      input_hash = build_input_hash(input)

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

    while game.active?
      shot_firing_phase
    end
  end

  def shot_firing_phase
    puts "Choose a player and grid location to fire at. Example: fire player_name x y\n"
    input      = gets.downcase.split(/\W+/)
    input_hash = build_shot_input_hash(input)
    process_shot(input_hash)
  end

  def process_shot(input)
    if validator.valid_shot?(input)
      fire_shot(input)
    else
      puts 'Invalid input. Please try again.'
    end
  end

  def fire_shot(input)
    shot_position = {x: input[:x], y: input[:y]}
    player        = game.players[input[:player]]

    if player.shot_hit?(shot_position)
      player.process_hit(shot_position)
      puts build_all_rows
      puts 'Shot hit!'
    else
      player.misses_against << shot_position
      puts build_all_rows
      puts 'Shot missed!'
    end
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

  def build_shot_input_hash(input)
    input_hash = {
      player: input[1],
      x:      input[2].to_i,
      y:      input[3].to_i
    }

    return input_hash
  end

  def all_ships_placed?
    game.ships.length == player.ships.length
  end

end
