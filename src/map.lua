-- Tendrías que traerte a hexmaniac aquí para que reconozca los colores
local hex = require("libs.hexmaniac") 

local map = {}

function map.draw_borders()
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
end

return map