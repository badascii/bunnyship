require_relative '../lib/display'
require_relative '../lib/player'
require_relative '../lib/ship'

type           = ARGV[0] || 'console'
display        = Display.new(type: type)
positions      = [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}, {x: 5, y: 1}]
damage         = [{x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 1}, {x: 5, y: 1}]
misses_against = [{x: 9, y: 1}, {x: 9, y: 2}, {x: 9, y: 3}, {x: 9, y: 4}, {x: 9, y: 5}]
battleship     = Ship.new(type: 'battleship', positions: positions)

if display.type == 'html'
  display.player.ships << battleship
  display.write_html('./test/battleship_test.html')
else
  puts display.build_complete_grid

  display.player.ships << battleship

  puts display.build_complete_grid

  display.player.ships[0].damage = damage.to_set

  display.player.misses_against = misses_against.to_set

  puts display.build_complete_grid
end
