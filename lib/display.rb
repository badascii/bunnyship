require 'erb'
require_relative 'game'
require_relative 'player'

class Display

  attr_accessor :game, :player

  def initialize(opts={})
    @game   = opts[:game]   || Game.new
    @player = opts[:player] || Player.new
  end

  def build_all_rows
    all_rows = {}
    row = []

    game.grid.positions do |position|

      row << player.get_position_status(position)

      if position[:x] == game.grid.width
        all_rows[position[:y]] = row
        row = []
      end
    end

    return all_rows
  end

  def build_x_legend
    x_legend = []

    game.grid.width.times { |x| x_legend << (x + 1).to_s }

    return x_legend
  end

end
