require 'set'

class Grid
  attr_reader :height, :width

  def initialize(opts={})
    @height = opts[:height] || 10
    @width  = opts[:width]  || 10
  end

  def positions
    column.each do |y|
      row.each do |x|
        yield({ x: x, y: y })
      end
    end
  end

  def row
    (1..width).to_a
  end

  def column
    (1..height).to_a
  end

end
