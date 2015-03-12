require 'erb'
require_relative 'grid'
require_relative 'player'

class Display

  attr_accessor :grid, :player, :type

  def initialize(opts={})
    @grid   = opts[:grid]   || Grid.new
    @player = opts[:player] || Player.new
    @type   = opts[:type]   || "console"
  end

  def build_row(position)
    output_string  = ""
    output_string += get_status(position)
    output_string += "#{position[:y]}#{line_break}" if position[:x] == grid.width

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

    return x_legend + "#{line_break}"
  end

  def build_complete_grid
    build_x_legend + build_all_rows
  end

  def build_html
    b        = binding
    erb      = File.read("./lib/html_template.erb")
    template = ERB.new(erb)
    html     = template.result(b)

    return html
  end

  def line_break
    return "\n"    if type == "console"
    return "</br>" if type == "html"
  end

  def write_html(path)
    html = build_html
    File.write(path, html)
  end

end
