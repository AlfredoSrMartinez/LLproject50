require ("src.utils")
require ("src.map")
require ("src.snakes")
require ("src.berries")

local hex = require("libs.hexmaniac")
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

	snake = new_snake()

	input = true
	timer = 0
	score = 0
	head = '>'
	game_state = "menu"
end

--updating the game state
function love.update(dt)
	background_music:play()
end

--drawing the state on the screen
function love.draw()
	love.graphics.setBackgroundColor(hex.rgb('011A00'))

	love.graphics.setColor(hex.rgb('046508'))

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