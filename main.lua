local hex = require("libs.hexmaniac")
local snake
local score 

--setting up the game state
function love.load()
	love.mouse.setVisible(false)

	snake = {}
	snake.head_x_position = 0
	snake.head_y_position = 0
	snake.head_width = 1
	snake.head_height = 1
	snake.speed = 100

	berry = {}
	berry.x_position = love.math.random(0,800)
	berry.y_position = love.math.random(0,600)
	berry.berry_width = 1
	berry.berry_height = 1

	score = 0
end

--updating the game state
function love.update(dt)
	if love.keyboard.isDown("right",'d') then

        snake.head_x_position = snake.head_x_position + snake.speed * dt
    end    

    if love.keyboard.isDown("left",'a') then
        snake.head_x_position = snake.head_x_position - snake.speed * dt
    end  

    if love.keyboard.isDown("up",'w') then
        snake.head_y_position = snake.head_y_position - snake.speed * dt
    end    

    if love.keyboard.isDown("down",'s') then
        snake.head_y_position = snake.head_y_position + snake.speed * dt
    end  

    if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end
   	--gemini to check why not working 
   	if(CheckCollision(snake.head_x_position,snake.head_y_position,snake.head_width,snake.head_height, berry.x_position,berry.y_position,berry.berry_width,berry.berry_height)) then
		score = score + 1
		print("score = " .. score)
		berry.x_position = love.math.random(0,800)
		berry.y_position = love.math.random(0,600)

	end
	   		
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

--drawing the state on the screen
function love.draw()
	love.graphics.setBackgroundColor(hex.rgb('508a3d'))
	love.graphics.print( "O", snake.head_x_position, snake.head_y_position)
	love.graphics.print( "@", berry.x_position, berry.y_position)

end