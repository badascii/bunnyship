require 'set'

class Grid
  attr_reader :height, :width

  def initialize(opts={})
    @height = opts[:height] || 10
    @width  = opts[:width]  || 10
  end
end