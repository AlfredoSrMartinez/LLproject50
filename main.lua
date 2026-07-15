local hex = require("libs.hexmaniac")
local input
local snake
local score
local head 
local screen_width 
local screen_height
local game_state

--setting up the game state
function love.load()
	--the mouse is hidden to not bother when playing the game 
	love.mouse.setVisible(false)
	love.graphics.setNewFont(30)

	--berry values
	screen_width = 800
	screen_height = 600

	--here we declare the snake values TODO abstract the code to another file
	snake = {}
	snake.x_position = 25
	snake.y_position = 25
	--change the width-heihgt for better collision gemini suggestion
	snake.width = 20
	snake.height = 20
	snake.speed = 100

	--here we declare the body of the snake gemini involved
	snake_segments = {}
	snake_segments.x_position = 25
	snake_segments.y_position = 25

	--here we declare the fruit the snake eat to grow appears at any location in the
	--screen limits 
	berry = {}
	berry.x_position = love.math.random(0,screen_width - 25)
	berry.y_position = love.math.random(0,screen_height - 25)
	berry.berry_width = 20
	berry.berry_height = 20

	--score variable to just upload the value 
	input = true
	score = 0
	head = '>'
	--gemini remembered me about game states
	game_state = "game_on"
end

--updating the game state
function love.update(dt)
	if input then
		if love.keyboard.isDown("right",'d') then
        	snake.x_position = snake.x_position + snake.speed * dt
        	head = '>'    

    	elseif love.keyboard.isDown("left",'a') then
        	snake.x_position = snake.x_position - snake.speed * dt
        	head = '<'

    	elseif love.keyboard.isDown("up",'w') then
        	snake.y_position = snake.y_position - snake.speed * dt
        	head = '^'

    	elseif love.keyboard.isDown("down",'s') then
        	snake.y_position = snake.y_position + snake.speed * dt
        	head = 'v'
    	end  
   	end

   	if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end

   	if love.keyboard.isDown('r') then
    	snake.x_position = 25
    	snake.y_position = 25
    	score = 0
    	input = true
    	game_state = "game_on"

    	berry.x_position = love.math.random(0,screen_width - 25)
		berry.y_position = love.math.random(0,screen_height - 25)

   	end

   	if love.keyboard.isDown('o') then
    	score = score + 5
   	end
   	--gemini to check why not working score goes up and segment never reaches 2 iguess
	--check the collision of the objects via the function with AABB the score updates    	
   	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, berry.x_position,berry.y_position,berry.berry_width,berry.berry_height)) then
			score = score + 1
			print("score = " .. score)
			berry.x_position = love.math.random(0,screen_width - 25)
			berry.y_position = love.math.random(0,screen_height - 25)
	end

   	--how to do a for and fix it snake segments only a table with mini table
    --the snake body need to check later 
   	for i = score, 2 , -1 do
   		snake_segments[i] = snake_segments[i-1]
   	end
   	--snake body mini table with x position and y position
   	snake_segments[1] = {x_position = snake.x_position-2, y_position = snake.y_position-2}

   	if (score == 256) then
   		love.graphics.print( "You Win!", screen_width - 495, 300)
   	end

   	if(snake.x_position <= 0 or snake.y_position <= 0 or snake.x_position >= 800 or snake.y_position >= 600) then
   		game_state = "game_over"
   		input = false
   	end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  	return 	x1 < x2+w2 and
         	x2 < x1+w1 and
         	y1 < y2+h2 and         
         	y2 < y1+h1
end

--drawing the state on the screen
function love.draw()
	love.graphics.setBackgroundColor(hex.rgb('508a3d'))
	love.graphics.setColor(hex.rgb('fafa07'))

	--top side 
	for i = -7, 275 do
		love.graphics.print("#",i,0)
	end
	for i = 470, 779 do
		love.graphics.print("#",i,0)
	end
	--left side 
	for i = 0, 569 do
		love.graphics.print("#",0,i)
	end
	--right side 
	for i = 0, 569 do
		love.graphics.print("#",779,i)
	end
	--down side 
	for i = 0, 779 do
		love.graphics.print("#",i,569)
	end
	--gemini error en el for 
	for i = 1, score do 
		love.graphics.print( "".. head, snake_segments[i].x_position, snake_segments[i].y_position)
	end
	love.graphics.print( "SCORE: " .. score, screen_width - 495, 0)
	love.graphics.print( "" .. head, snake.x_position, snake.y_position)
	love.graphics.print( "@", berry.x_position, berry.y_position)

	if (game_state == "game_over") then
		love.graphics.print( "GAME OVER", screen_width - 495, 100)
		love.graphics.print( "Press R to restart!", screen_width - 495, 200)
	end
end	