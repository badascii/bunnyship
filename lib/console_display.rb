class ConsoleDisplay

  attr_accessor :grid

  def initialize(grid)
    @grid = grid
  end

  def build_row(position)
    output_string = ""

    output_string += position[:y].to_s if position[:x] == 1
    output_string += get_status

    output_string += "\n" if position[:x] == width
  end

  def build_all_rows
    output_string = ""

    grid.positions.each do |position|
      output_string += build_row(position)
    end

    return output_string
  end

  def get_status(position)
    @player.ships.each do |ship|
      if ship.damage.include?(position)
        return '*'
      elsif ship.positions.include?(position)
        return 'S'
      elsif @player.misses_against.include?(position)
        return '!'
      else
        return '~'
      end
    end
  end

  def build_x_legend
    x_legend = ""

    grid.width.times { |x| x_legend << (x + 1).to_s }

    return x_legend + "\n"
  end

  def build_complete_grid
    build_x_legend + build_all_rows
  end

end
