require 'erb'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/display'

class HTMLDisplay < Display

  ICON_MAPPING = {
    'empty'      => "<img src='../public/images/wave.png' />",
    'miss'       => '!',
    'hit'        => '*',
    'carrier'    => 'A',
    'battleship' => 'B',
    'cruiser'    => 'C',
    'destroyer'  => 'D',
    'submarine'  => 'S'
  }

  attr_accessor :game, :player

  def initialize(opts={})
    @game   = opts[:game]   || Game.new
    @player = opts[:player] || Player.new
  end

  def build_html
    b        = binding
    erb      = File.read('./lib/html_template.erb')
    template = ERB.new(erb)
    html     = template.result(b)

    return html
  end

  def write_html(path)
    html = build_html
    File.write(path, html)
  end

end
