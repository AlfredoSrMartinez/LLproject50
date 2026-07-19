require ("src.utils")

local head
local timer

function new_snake (current_direction, x_position, y_position, width, height, speed)
	local snake = {}
	snake.current_direction = current_direction
	snake.x_position = x_position
	snake.y_position = y_position
	snake.width = width
	snake.height = height
	snake.speed = speed	
	snake.snake_segments = {}

	head = '>'
	timer = 0

	function snake:update(dt,current_score)
		--suggestion made by gemini
		if love.keyboard.isDown("right",'d') and snake.current_direction ~= "left" then
        	snake.current_direction = "right"
        	head = '>'    

    	elseif love.keyboard.isDown("left",'a')  and snake.current_direction ~= "right" then
    		snake.current_direction = "left"
        	head = '<'

    	elseif love.keyboard.isDown("up",'w') and snake.current_direction ~= "down" then
        	snake.current_direction = "up"
        	head = '^'

    	elseif love.keyboard.isDown("down",'s') and snake.current_direction ~= "up" then
        	snake.current_direction = "down"
        	head = 'v'
    	end  

    	if snake.current_direction == "right" then 
   			snake.x_position = snake.x_position + snake.speed * dt
   	
   		elseif snake.current_direction == "left" then
   			snake.x_position = snake.x_position - snake.speed * dt

   		elseif snake.current_direction == "up" then
   			snake.y_position = snake.y_position - snake.speed * dt

   		elseif snake.current_direction == "down" then
   			snake.y_position = snake.y_position + snake.speed * dt
   		end

   		timer = timer + dt

		if timer >= (snake.width / snake.speed) then
        	for i = current_score, 2 , -1 do
        		snake.snake_segments[i] = snake.snake_segments[i-1]
    		end
    
    		snake.snake_segments[1] = {x_position = snake.x_position, y_position = snake.y_position}
    	
    		timer = 0
		end
	end

	function snake:draw()
		for i = 1, #snake.snake_segments do 
			love.graphics.print( "".. head, snake.snake_segments[i].x_position, snake.snake_segments[i].y_position+2)
		end
		love.graphics.print( "" .. head, snake.x_position, snake.y_position)
	end

	return snake
end