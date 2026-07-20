# SNAKE EAT BERRIES THE GAME
## Video Demo:  <URL HERE>
## Description: 
This is a project I have been working on for the past few days. I have been struggling with coding for a while, and to improve my skills I decided to build a project with a small scope. At first, I tried making a videogame but soon found that it was way harder than I thought. Later, I remembered that some people make videos about coding Snake in C. I thought that would be a cool project, but for the sake of learning, I decided to pick that concept and implement it in another language and environment. Because of this, I decided to go with LÖVE2D and Lua.

## File Summary

1.- **main.lua**
main file from the program it loads the library hexmaniac for color correction, and the map file for drawing the borders of the game, other useful variables such as game_State, input, timer, score for the game to work properly. In load the music, sound effects, graphics such as title cards and the variables already mentioned are intialized, with the functions snake and berry that we are going to talk about later in the readme. In update we make the snake and the music start, some additional controls are displayed such as escape, restart, and increasing the snake size, it also has the winning conditions, and the code that checks for the snake to collition with itself, with the borders, and the fruits. In draw the color of the background and the font is established, the snake and the map too, we print the score and the berries, and for last the game states conditions to display on the screen the current of them

2.- **conf.lua**
Here we just establish in the file the version of the love framework we are currently using, the title of the window, the icon of the same window, and the height and width

3.- **berries.lua**
for modularity i decided to move the berry declaration to a different file where it is decided the sprite, the position width height and score it is for better modularity, i think should be good to add the drawing here but later hehe

4.- **map.lua**
for the sake of cleanliness on the main code, i just abstracted the map drawings made with fors again, it can be later changed for more abstractions like a function 

5.- **snake.lua**
For modularity i decided to move the snake declaration and movement and the drawing of the snake to another file to keep this correctly organized to change it later in an easy way

the movement involves that the snake can not move in the same direction making that it moves on the same point making it not keep moving so we implement the snake direction making it not possible to keep moving on its own center up down left or right

6.- **utils.lua**
Here we have the AABB collision function that just checks if the x position and y position with the height and with of object 1 enter in the x position and y position with the height and width of object 2 making everythingo of the above possible, the function is kept in another file for usage in other files

## Design Choices

lorem ipsum

## Built with: 

+ Love2d 
+ Lua 
+ MS Paint

## Getting started

### Prerequisites
To run this game, you need to have the LÖVE framework (LÖVE2D) installed on your computer. 
You can download the appropriate version for your operating system (Windows, macOS, or Linux) from their official website:
* [LÖVE - Free 2D Game Engine](https://love2d.org/)

### Installation 
1. **Clone the repo:**
```sh

git clone https://github.com/AlfredoSrMartinez/LLproject50.git

```

2. **Navigate to the project directory.**

3. **Run the game using LÖVE:**

+ On Windows: You can drag and drop the LLproject50 folder directly onto the love.exe shortcut, or run love . in your terminal inside the folder.

+ On macOS / Linux: Open your terminal, navigate to the folder containing main.lua, and type love .

## Usage
### Snake movement:
+ (w, a, s, d) up, left, down, right
+ ( 1 ) start the game 
+ ( r ) restart the game  

## Contact

Alfredo Martinez -@alfredomrtnz_ -martinezsralfredo@gmail.com

Project Link: https://github.com/AlfredoSrMartinez/LLproject50

## Acknowledgments 
### sound effects
+ https://sounds.spriters-resource.com/wii/ssbb/asset/394165/
### music
+ Donkey Kong Country OST (Super Nintendo) - Track 0623 - Bonus Room Blitz
### libraries used
+ https://github.com/LavenderTheGreat/hexmaniac
### ia implemented as a more potent rubber duck
+ Gemini AI