require 'set'

class Grid
  attr_reader :height, :width

  def initialize(opts={})
    @height = opts[:height] || 10
    @width  = opts[:width]  || 10
  end

  def build_positions
    pos_array = []
    height.times do |y|
      width.times do |x|
        pos_array << { x: x + 1, y: y + 1, status: '~' }
      end
    end
    return pos_array
  end

end
