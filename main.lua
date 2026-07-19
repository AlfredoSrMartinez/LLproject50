require ("src.utils")
require ("src.snake")
require ("src.berries")

local hex = require("libs.hexmaniac")
local map = require ("src.map")
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

	--sounds 
	background_music = love.audio.newSource("assets/audio/music/Donkey Kong Country OST (Super Nintendo) - Track 0623 - Bonus Room Blitz.mp3", "stream")
	damage_taken = love.audio.newSource("assets/audio/effects/damage_taken.wav", "static")
	epic_victory = love.audio.newSource("assets/audio/effects/win.wav", "static")
	berry_eaten = love.audio.newSource("assets/audio/effects/eat_berry.wav", "static")

	--images 
	awesome_wallpaper = love.graphics.newImage("assets/images/titlecards/epic_wallpaper.jpg")
	le_defeat = love.graphics.newImage("assets/images/titlecards/le_defeat.jpg")
	le_win = love.graphics.newImage("assets/images/titlecards/le_win.jpg")

	screen_width = 757
	screen_height = 546

	snake = new_snake("right", 25, 25, 20, 20, 100)

	berry = new_berry(love.math.random(25,screen_width), love.math.random(25,screen_height), 20, 20, 1, '@')

	evil_berry = new_berry(-10, -10, 20, 20, -1, '&')

	input = true
	timer = 0
	score = 0
	head = '>'
	game_state = "menu"
end

--updating the game state
function love.update(dt)
	background_music:play()

	snake:update(dt,score)

	if love.keyboard.isDown("escape") then
    	love.event.quit()
   	end

   	if love.keyboard.isDown('r') then
    	-- ¡La fábrica nos da una serpiente nuevecita y limpia!
    	snake = new_snake("right", 25, 25, 20, 20, 100) 
    	score = 0
    	input = true
    	game_state = "game_on"

    	berry.x_position = love.math.random(25,screen_width)
		berry.y_position = love.math.random(25,screen_height)

		evil_berry.x_position = -10
		evil_berry.y_position = -10
   	end

   	if love.keyboard.isDown('o') then
    	score = score + 5
   	end

   	if love.keyboard.isDown('1') then
    	game_state = "game_on"
    	snake.current_direction = "right"
   	end

   	if (score >= 256) then
   		game_state = "epic_victory"
   		input = false
   		epic_victory:play()
   	end

   	-- Revisar si la serpiente choca con su propio cuerpo
	for i = 5, #snake.snake_segments do
    	if CheckCollision(snake.x_position, snake.y_position, snake.width, snake.height, snake.snake_segments[i].x_position, snake.snake_segments[i].y_position, 20, 20) then
        	game_state = "game_over"
        	snake.current_direction = "stop"
        	input = false
        	damage_taken:play()
        end
    end

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

	if(CheckCollision(snake.x_position,snake.y_position,snake.width,snake.height, evil_berry.x_position,evil_berry.y_position,evil_berry.berry_width,evil_berry.berry_height)) then
			score = score + evil_berry.berry_score -- Aquí cambiamos a suma
			print("score = " .. score)
			evil_berry.x_position = love.math.random(25, screen_width-100)
			evil_berry.y_position = love.math.random(25, screen_height-100)
			berry_eaten:play()
	end

   	if(snake.x_position <= 22 or snake.y_position <= 22 or snake.x_position >= 757 or snake.y_position >= 546) and game_state == "game_on" then
   		game_state = "game_over"
   		snake.current_direction = "stop"
   		input = false
   		damage_taken:play()
   	end
end

--drawing the state on the screen
function love.draw()
	love.graphics.setBackgroundColor(hex.rgb('011A00'))

	love.graphics.setColor(hex.rgb('046508'))

	snake:draw()
	map.draw_borders()

	love.graphics.print( "SCORE: " .. score, screen_width - 455, 0)
	love.graphics.print( ""..berry.berry_sprite, berry.x_position, berry.y_position)
	love.graphics.print( ""..evil_berry.berry_sprite, evil_berry.x_position, evil_berry.y_position)

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