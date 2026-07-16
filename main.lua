local hex = require("libs.hexmaniac")
local input
local timer
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

	--sounds 
	background_music = love.audio.newSource("assets/audio/music/Donkey Kong Country OST (Super Nintendo) - Track 0623 - Bonus Room Blitz.mp3", "stream")
	damage_taken = love.audio.newSource("assets/audio/effects/damage_taken.wav", "static")
	epic_victory = love.audio.newSource("assets/audio/effects/win.wav", "static")
	berry_eaten = love.audio.newSource("assets/audio/effects/eat_berry.wav", "static")

	--images 
	awesome_wallpaper = love.graphics.newImage("assets/images/titlecards/epic_wallpaper.jpg")
	le_defeat = love.graphics.newImage("assets/images/titlecards/le_defeat.jpg")
	le_win = love.graphics.newImage("assets/images/titlecards/le_win.jpg")

	--berry values
	screen_width = 757
	screen_height = 546

	--here we declare the snake values TODO abstract the code to another file
	snake = {}
	snake.current_direction = "right"
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
	berry.x_position = love.math.random(25,screen_width)
	berry.y_position = love.math.random(25,screen_height)
	berry.berry_width = 20
	berry.berry_height = 20

	evil_berry = {}
	evil_berry.x_position = -10
	evil_berry.y_position = -10
	evil_berry.evil_berry_width = 20
	evil_berry.evil_berry_height = 20

	--score variable to just upload the value 
	input = true
	timer = 0
	score = 0
	head = '>'
	--gemini remembered me about game states
	game_state = "menu"
end

--updating the game state
function love.update(dt)
	background_music:play()
	if input then
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

   	if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end

   	if love.keyboard.isDown('r') then
    	snake.x_position = 25
    	snake.y_position = 25
    	score = 0
    	input = true
    	game_state = "game_on"
    	snake_segments = {}

    	berry.x_position = love.math.random(25,screen_width)
		berry.y_position = love.math.random(25,screen_height)

		evil_berry.x_position = -10
		evil_berry.y_position = -10
   	end

   	if love.keyboard.isDown('1') then
    	game_state = "game_on"
    	snake.current_direction = "right"
   	end

   	if love.keyboard.isDown('o') then
    	score = score + 5
   	end
   	--gemini to check why not working score goes up and segment never reaches 2 iguess
	--check the collision of the objects via the function with AABB the score updates    	
   	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, berry.x_position,berry.y_position,berry.berry_width,berry.berry_height)) then
			score = score + 1
			print("score = " .. score)
			berry.x_position = love.math.random(25,screen_width)
			berry.y_position = love.math.random(25,screen_height)
			berry_eaten:play()
	end

	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, evil_berry.x_position,evil_berry.y_position,evil_berry.evil_berry_width,evil_berry.evil_berry_height)) then
			score = score - 1
			print("score = " .. score)
			evil_berry.x_position = love.math.random(25, screen_width-100)
			evil_berry.y_position = love.math.random(25, screen_height-100)
			berry_eaten:play()
	end

   	--how to do a for and fix it snake segments only a table with mini table
    --the snake body need to check later 
    --gemini remembered me about the # function in lua
    --gemini fixed this
	timer = timer + dt

	if timer >= (snake.width / snake.speed) then
        for i = score, 2 , -1 do
        	snake_segments[i] = snake_segments[i-1]
    	end
    
    	snake_segments[1] = {x_position = snake.x_position, y_position = snake.y_position}
    	
    	timer = 0
	end

	-- gemini help maaking this 
	for i = 5, #snake_segments do
    	if CheckCollision(snake.x_position, snake.y_position, snake.width, snake.height, snake_segments[i].x_position, snake_segments[i].y_position, 20, 20) then
        	game_state = "game_over"
        	snake.current_direction = "stop"
        	input = false
        	damage_taken:play()
        end
    end

    if (score == 10) then
    	evil_berry.x_position = love.math.random(25,screen_width-100)
		evil_berry.y_position = love.math.random(25,screen_height-100)
   	end

   	if (score >= 256) then
   		game_state = "epic_victory"
   		input = false
   		epic_victory:play()
   	end

   	if(snake.x_position <= 22 or snake.y_position <= 22 or snake.x_position >= 757 or snake.y_position >= 546) and game_state == "game_on" then
   		game_state = "game_over"
   		snake.current_direction = "stop"
   		input = false
   		damage_taken:play()
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
	love.graphics.setBackgroundColor(hex.rgb('011A00'))

	love.graphics.setColor(hex.rgb('046508'))

	--top side x, y 
	for i = -7, 275 do
		love.graphics.print("#",i,0)
	end
	for i = 490, 779 do
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
	for i = 1, #snake_segments do 
		love.graphics.print( "".. head, snake_segments[i].x_position, snake_segments[i].y_position+2)
	end
	love.graphics.print( "SCORE: " .. score, screen_width - 455, 0)
	love.graphics.print( "" .. head, snake.x_position, snake.y_position)
	love.graphics.print( "@", berry.x_position, berry.y_position)
	love.graphics.print( "&", evil_berry.x_position, evil_berry.y_position)

	if (game_state == "menu") then
		love.graphics.draw(awesome_wallpaper, 0, 0)
		love.graphics.print( "Press 1 to tart!", screen_width - 565, 200)
		snake.current_direction = "stop"
	end

	if (game_state == "game_over") then
		love.graphics.draw(le_defeat, 0, 0)
		love.graphics.print( "Press R to restart!", 490, 550)
	end

	if (game_state == "epic_victory") then
		love.graphics.draw(le_win, 0, 0)
		love.graphics.print( "Press R to restart!", 490, 550)
	end
end	