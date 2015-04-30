require 'set'

class Player

  attr_accessor :name, :ships, :misses_against

  HIT   = 'hit'
  MISS  = 'miss'
  EMPTY = 'empty'

  def initialize(opts={})
    @name  = opts[:name]  || 'Jimmy'
    @ships = opts[:ships] || []

    if opts[:misses_against]
      @misses_against = opts[:misses_against].to_set
    else
      @misses_against = Set.new
    end
  end

  def get_position_status(position)
    return MISS if misses_against.include?(position)

    ships.each do |ship|
      if ship.damage.include?(position)
        return HIT
      elsif ship.positions.include?(position)
        return ship.type
      end
    end
    return EMPTY
  end

  def active_ships
   active_ships = []
   ships.each do |ship|
      unless ship.destroyed?
        active_ships << ship
      end
    end
    return active_ships
  end

  def active?
    !active_ships.empty?
  end

  def shot_hit?(shot_position)
    ships.each do |ship|
      ship.positions.each do |position|
        return true if position == shot_position
      end
    end
    return false
  end

  def process_hit(position)
    ships.each do |ship|
      if ship.positions.include?(position)
        ship.damage << position
        return
      end
    end
  end

end
