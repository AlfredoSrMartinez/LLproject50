--files required to work
require ("src.utils")
require ("src.snake")
require ("src.berries")

--color library, and map function
local hex = require("libs.hexmaniac")
local map = require ("src.map")

--local variables
local game_state
local input
local timer
local score
local snake
local berry
local evil_berry
local screen_width 
local screen_height

--setting up the game state
function love.load()
	--mouse hidden, new font
	love.mouse.setVisible(false)
	love.graphics.setNewFont(30)

	--sound effects and music
	background_music = love.audio.newSource("assets/audio/music/Donkey Kong Country OST (Super Nintendo) - Track 0623 - Bonus Room Blitz.mp3", "stream")
	damage_taken = love.audio.newSource("assets/audio/effects/damage_taken.wav", "static")
	epic_victory = love.audio.newSource("assets/audio/effects/win.wav", "static")
	berry_eaten = love.audio.newSource("assets/audio/effects/eat_berry.wav", "static")

	--titlecards
	awesome_wallpaper = love.graphics.newImage("assets/images/titlecards/epic_wallpaper.jpg")
	le_defeat = love.graphics.newImage("assets/images/titlecards/le_defeat.jpg")
	le_win = love.graphics.newImage("assets/images/titlecards/le_win.jpg")

	--screen size width height
	screen_width = 757
	screen_height = 546

	--snake, berries declaration
	snake = new_snake("right", 25, 25, 20, 20, 100)

	berry = new_berry(love.math.random(25,screen_width), love.math.random(25,screen_height), 20, 20, 1, '@')

	evil_berry = new_berry(-10, -10, 20, 20, -1, '&')

	--local variables declaration
	input = true
	timer = 0
	score = 0
	head = '>'
	game_state = "menu"
end

--updating the game state
function love.update(dt)
	--music playing
	background_music:play()

	--snake movement
	snake:update(dt,score)

	--closing the game
	if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end

   	--secret key to increase snake size
   	if love.keyboard.isDown('o') then
    	score = score + 5
   	end

   	--starting the game
   	if love.keyboard.isDown('1') then
    	game_state = "game_on"
    	snake.current_direction = "right"
   	end

   	--press r to restart the game re starting everything
   	if love.keyboard.isDown('r') then
    	snake = new_snake("right", 25, 25, 20, 20, 100) 
    	score = 0
    	input = true
    	game_state = "game_on"

    	berry.x_position = love.math.random(25,screen_width)
		berry.y_position = love.math.random(25,screen_height)

		evil_berry.x_position = -10
		evil_berry.y_position = -10
   	end

   	--winning condition
   	if (score >= 256) then
   		game_state = "epic_victory"
   		input = false
   		epic_victory:play()
   	end

   	--snake collitions

   	--check for collition with snake´s own body
	for i = 5, #snake.snake_segments do
    	if CheckCollision(snake.x_position, snake.y_position, snake.width, snake.height, snake.snake_segments[i].x_position, snake.snake_segments[i].y_position, 20, 20) then
        	game_state = "game_over"
        	snake.current_direction = "stop"
        	input = false
        	damage_taken:play()
        end
    end

    --check for collition with berry to increase score, if score is more than 10 evil berries start to spawn
   	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, berry.x_position,berry.y_position,berry.berry_width,berry.berry_height)) then
			score = score + berry.berry_score
			print("score = " .. score)
			berry.x_position = love.math.random(25,screen_width)
			berry.y_position = love.math.random(25,screen_height)
			berry_eaten:play()
		if (score == 10) then
    		evil_berry.x_position = love.math.random(25,screen_width-100)
			evil_berry.y_position = love.math.random(25,screen_height-100)
   		end
	end

	--check for collition with evil_berry to decrease score
	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, evil_berry.x_position,evil_berry.y_position,evil_berry.berry_width,evil_berry.berry_height)) then
			score = score + evil_berry.berry_score 
			print("score = " .. score)
			evil_berry.x_position = love.math.random(25, screen_width-100)
			evil_berry.y_position = love.math.random(25, screen_height-100)
			berry_eaten:play()
	end

	--check for collition with the limits of the screen
   	if(snake.x_position <= 22 or snake.y_position <= 22 or snake.x_position >= 757 or snake.y_position >= 546) and game_state == "game_on" then
   		game_state = "game_over"
   		snake.current_direction = "stop"
   		input = false
   		damage_taken:play()
   	end
end

--drawing the state on the screen
function love.draw()
	--background color of the screen and the color of the font
	love.graphics.setBackgroundColor(hex.rgb('011A00'))
	love.graphics.setColor(hex.rgb('046508'))

	--drawing the snake and the map
	snake:draw()
	map.draw_borders()

	--draw the score and the berries
	love.graphics.print( "SCORE: " .. score, screen_width - 455, 0)
	love.graphics.print( ""..berry.berry_sprite, berry.x_position, berry.y_position)
	love.graphics.print( ""..evil_berry.berry_sprite, evil_berry.x_position, evil_berry.y_position)

	--game states 

	--game state for the main menu
	if (game_state == "menu") then
		love.graphics.draw(awesome_wallpaper, 0, 0)
		love.graphics.print( "Press 1 to tart!", screen_width - 565, 200)
		snake.current_direction = "stop"
	end

	--game state for the game over
	if (game_state == "game_over") then
		love.graphics.draw(le_defeat, 0, 0)
		love.graphics.print( "Press R to restart!", 490, 550)
	end

	--game state for the winning screen
	if (game_state == "epic_victory") then
		love.graphics.draw(le_win, 0, 0)
		love.graphics.print( "Press R to restart!", 490, 550)
	end
end