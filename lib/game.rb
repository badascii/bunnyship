require_relative '../lib/grid'

class Game

  attr_accessor :ships, :grid, :players

  def initialize(opts={})
    @ships   = opts['ships']   || {}
    @grid    = opts['grid']    || Grid.new
    @players = opts['players'] || []
  end

  def valid_fleet?(player_ships)
    return false if player_ships.length != ships.length
    return true
  end

  def valid_ship?(ship)
    return false unless ships.has_key?(ship[0])
    return false unless ships[ship[0]] == ship[1].length
    return true
  end

end
