class Player

  attr_accessor :name, :ships, :misses_against

  def initialize(opts={})
    @name  = opts[:name]  || 'Jimmy Bob'
    @ships = opts[:ships] || []

    if opts[:misses_against]
      @misses_against = opts[:misses_against].to_set
    else
      @misses_against = Set.new
    end
  end

  def active_ships
   active_ships = []
   @ships.each do |ship|
      unless ship.destroyed?
        active_ships << ship
      end
    end
    return active_ships
  end

  def active?
    !active_ships.empty?
  end

end