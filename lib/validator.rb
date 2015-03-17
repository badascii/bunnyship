class Validator

	attr_accessor :game

	def initialize(game)
	  @game = game
	end

	def valid_ship?(opts)
		type 			  = opts[:type]
		x 				  = opts[:x]
		y 				  = opts[:y]

		return false unless valid_type?(type)
		return false unless x_exists?(x)
		return false unless y_exists?(y)
		return false unless valid_alignment?(opts)
		return true
	end

	def valid_type?(type)
		game.ships.has_key?(type)
	end

	def x_exists?(x)
		x <= game.grid.width && x > 0
	end

	def y_exists?(y)
		y <= game.grid.height && y > 0
	end

	def valid_width?(x, ship_length)
		(x + ship_length - 1) <= game.grid.width
	end

	def valid_height?(y, ship_length)
		(y + ship_length - 1) <= game.grid.height
	end

	def valid_alignment?(opts)
		x						= opts[:x]
		y						= opts[:y]
		alignment   = opts[:alignment]
		ship_length = game.ships[opts[:type]]

		if alignment == 'h'
			return false unless valid_width?(x, ship_length)
		elsif alignment == 'v'
			return false unless valid_height?(y, ship_length)
		end

		return true
	end

end
