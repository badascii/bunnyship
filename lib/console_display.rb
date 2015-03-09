class ConsoleDisplay

  attr_accessor :grid, :player

  def initialize(opts={})
    @grid   = opts[:grid]   || Grid.new
    @player = opts[:player] || Player.new
  end

  def build_row(position)
    output_string  = ""
    output_string += position[:y].to_s if position[:x] == 1
    output_string += get_status(position)
    output_string += "\n" if position[:x] == grid.width

    return output_string
  end

  def build_all_rows
    output_string = ""

    grid.positions do |position|
      output_string += build_row(position)
    end

    return output_string
  end

  def get_status(position)
    return '!' if @player.misses_against.include?(position)

    @player.ships.each do |ship|
      if ship.damage.include?(position)
        return '*'
      elsif ship.positions.include?(position)
        return ship.type[0].upcase
      end
    end

    return '~'
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
