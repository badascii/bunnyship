require_relative '../lib/grid'

class Game

  attr_accessor :ships, :grid, :players, :id

  def initialize(opts={})
    @ships   = opts[:ships]   || {}
    @grid    = opts[:grid]    || Grid.new
    @players = opts[:players] || {}
  end

  def valid_fleet?(player_ships)
    return false if player_ships.length != ships.length
    return true
  end

  def valid_ship?(ship)
    return false unless ships.has_key?(ship[:type])
    return false unless ships[ship] == ship.size
    return true
  end

  def active?
    return true if active_player_count == 1
    return false
  end

  def active_player_count
    player_count = 0

    players.each do |player_name, player|
      player_count += 1 if player.active?
    end

    return player_count
  end

end
