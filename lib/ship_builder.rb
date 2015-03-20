require_relative '../lib/ship'

class ShipBuilder

  attr_accessor :type, :x, :y, :alignment, :length, :positions, :ship

  def initialize(opts)
    @type      = opts[:type]
    @x         = opts[:x]
    @y         = opts[:y]
    @alignment = opts[:alignment]
    @length    = opts[:length]
    @positions = get_positions
    @ship      = Ship.new(type: type, positions: positions)
  end

  private

  def get_positions
    positions = Set.new

    length.times do |i|
      if alignment == 'h'
        positions << {x: x + i, y: y}
      elsif alignment == 'v'
        positions << {x: x, y: y + i}
      end
    end
    return positions
  end

end
