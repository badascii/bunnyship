require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/html_display'
require_relative '../lib/player'
require_relative '../lib/grid'
require_relative '../lib/ship'

class HTMLDisplayTest < MiniTest::Test

  def setup
    @html_display = HTMLDisplay.new
    @player       = Player.new
    grid_2x2      = Grid.new(width: 2, height: 2)
    @game_2x2     = Game.new(grid: grid_2x2)
    grid_5x5      = Grid.new(width: 5, height: 5)
    @game_5x5     = Game.new(grid: grid_5x5)
  end

  def test_build_html
    expected_html = File.read('./test/expected_html.html')
    assert_equal expected_html, @html_display.build_html
  end

  def test_write_html
    expected_html  = File.read('./test/expected_html.html')
    @html_display.write_html('./test/battleship_test.html')
    actual_html    = File.read('./test/battleship_test.html')

    assert_equal expected_html, actual_html
  end

end
