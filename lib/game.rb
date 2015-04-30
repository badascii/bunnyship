require_relative '../lib/grid'

class Game

  attr_accessor :ships, :grid, :players, :id, :turn_history, :turn_order, :current_turn

  DEFAULT_SHIPS = {
    'carrier'    => 5,
    'battleship' => 4,
    'submarine'  => 3,
    'cruiser'    => 3,
    'destroyer'  => 2
  }

  def initialize(opts={})
    @ships        = opts[:ships]   || DEFAULT_SHIPS
    @grid         = opts[:grid]    || Grid.new
    @players      = opts[:players] || {}
    @turn_order   = []
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

  def add(player)
    players[player.name] = player
    turn_order << player.name
  end

  def subtract(player)
    players.delete(player.name)
    turn_order.delete(player.name)
  end

  def set_turn_order
    raise ArgumentError.new('Not enough players!') if players.size <= 1
    turn_order.shuffle
  end

  def toggle_players
    current_player = turn_order.shift
    turn_order << current_player
    current_turn = current_player
  end

end
