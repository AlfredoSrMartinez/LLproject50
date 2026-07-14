local hex = require("libs.hexmaniac")
local snake
local score 

--setting up the game state
function love.load()
	--the mouse is hidden to not bother when playing the game 
	love.mouse.setVisible(false)
	--here we declare the snake values TODO abstract the code to another file
	snake = {}
	snake.x_position = 0
	snake.y_position = 0
	snake.width = 1
	snake.height = 1
	snake.speed = 150

	--here we declare the body of the snake gemini involved
	snake_segments = {}
	snake_segments.x_position = 0
	snake_segments.y_position = 0

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

        snake.x_position = snake.x_position + snake.speed * dt
    end    

    if love.keyboard.isDown("left",'a') then
        snake.x_position = snake.x_position - snake.speed * dt
    end  

    if love.keyboard.isDown("up",'w') then
        snake.y_position = snake.y_position - snake.speed * dt
    end    

    if love.keyboard.isDown("down",'s') then
        snake.y_position = snake.y_position + snake.speed * dt
    end  

    if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end

   	--gemini to check why not working score goes up and segment never reaches 2 iguess
   	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, berry.x_position,berry.y_position,berry.berry_width,berry.berry_height)) then
		score = score + 1
		print("score = " .. score)
		berry.x_position = love.math.random(0,800)
		berry.y_position = love.math.random(0,600)
	end

   	--how to do a for and fix it snake segments only a table with mini table
   	for i = score, 2 , -1 do
   		snake_segments[i] = snake_segments[i-1]
   	end

   	snake_segments[1] = {x_position = snake.x_position, y_position = snake.y_position}
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
	--gemini error en el for 
	for i = 1, score do 
		love.graphics.print( "o", snake_segments[i].x_position, snake_segments[i].y_position)
	end
	love.graphics.print( "O", snake.x_position, snake.y_position)
	love.graphics.print( "@", berry.x_position, berry.y_position)

end