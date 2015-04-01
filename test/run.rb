require 'yaml'
require_relative '../lib/console_display'
require_relative '../lib/html_display'
require_relative '../lib/game'

game       = Game.new
player     = Player.new(name: 'sketchmeister')

ships = YAML.load_file('./test/player_1.yaml')

ships.each do |ship|
  type      = ship['type']
  positions = ship['positions']
  positions.each do |pos|
    pos.keys.each do |key|
      pos[(key.to_sym rescue key) || key] = pos.delete(key)
    end
  end
  player.ships << Ship.new(type: type, positions: positions)
end

game.players[player.name] = player
settings   = YAML.load_file('./test/settings.yaml')
game.ships = settings['ships']

console_display = ConsoleDisplay.new(game: game, player: player)
html_display = HTMLDisplay.new(game: game, player: player)

console_display.run
html_display.write_html('./test/battleship_test.html')
