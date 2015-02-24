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

end
