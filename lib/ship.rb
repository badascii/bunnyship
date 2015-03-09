require 'set'

class Ship

  attr_accessor :type, :positions, :damage

  def initialize(opts)
    @type      = opts[:type]
    @positions = opts[:positions].to_set
    if opts[:damage]
      @damage = opts[:damage].to_set
    else
      @damage = Set.new
    end
  end

  def size
    positions.length
  end

  def shot_hit?(grid_position)
    positions.include?(grid_position)
  end

  def destroyed?
    damage == positions
  end

  def in_sequence?
    valid_positions = Set.new

    positions.each do |pos_1|
      positions.each do |pos_2|
        if neighboring_positions?(pos_1, pos_2)
          valid_positions << pos_1
        end
      end
    end

    valid_positions == positions
  end

  def neighboring_positions?(pos_1, pos_2)
    neighboring_positions_x?(pos_1, pos_2) || neighboring_positions_y?(pos_1, pos_2)
  end

  def neighboring_positions_x?(pos_1, pos_2)
    neighbors?(pos_1[:x], pos_2[:x]) && (pos_1[:y] == pos_2[:y])
  end

  def neighboring_positions_y?(pos_1, pos_2)
    neighbors?(pos_1[:y], pos_2[:y]) && (pos_1[:x] == pos_2[:x])
  end

  def neighbors?(pos_1, pos_2)
    (pos_1 - 1 == pos_2) || (pos_1 + 1 == pos_2)
  end

end
