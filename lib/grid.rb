require 'set'

class Grid
  attr_reader :height, :width

  def initialize(opts={})
    @height = opts[:height] || 10
    @width  = opts[:width]  || 10
  end

  def positions
    height_array = (1..height).to_a
    width_array = (1..width).to_a

    height_array.each do |y|
      width_array.each do |x|
        yield({ x: x, y: y })
      end
    end
  end

end
