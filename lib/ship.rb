class Ship

  attr_accessor :type, :positions, :damage

  def initialize(opts)
    @type      = opts[:type]
    @positions = opts[:positions]
    @damage    = opts[:damage]
  end

  def size
    positions.length
  end

  def shot_hit?(grid_position)
    positions.include?(grid_position)
  end

  def destroyed?
    if damage == positions
      true
    else
      false
    end
  end

  def in_sequence?
    positions.each do |position|
      # [{x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 5}]
      positions.each do |pos|
        if pos[:x] != position[:x]
          if (((position[:x] - 1) == pos[:x]) || ((position[:x] + 1) == pos[:x])) && ((position[:y] == pos[:y]) || (position[:y] == pos[:y]))
            return true
          end
        end
      end
    end
    return false
  end

  def neighboring_positions?(pos_1, pos_2)
    (pos_1 - 1 == pos_2) || (pos_1 + 1 == pos_2)
  end

end
