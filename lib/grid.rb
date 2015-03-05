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

  def build_rows
    output_string = ""

    build_positions.each do |pos|
      output_string += pos[:y].to_s if pos[:x] == 1
      output_string += pos[:status]
      output_string += "\n" if pos[:x] == width
    end

    return output_string
  end

  def build_x_legend
    x_legend = ""

    width.times { |x| x_legend << (x + 1).to_s }

    return x_legend + "\n"
  end

  def build_complete_grid
    build_x_legend + build_rows
  end

end
