function new_berry (x_position, y_position, berry_width, berry_height,berry_score,berry_sprite)
	local berry = {}
	berry.berry_sprite = berry_sprite
	berry.x_position = x_position
	berry.y_position = y_position
	berry.berry_width = berry_width
	berry.berry_height = berry_height
	berry.berry_score = berry_score

	return berry
end