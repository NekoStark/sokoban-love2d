Signal = require 'lib/signal'

local Title = {}

function Title:enter(from)
  music = love.audio.newSource("music/title.mp3")
  music:play()
end

function Title:draw()
    local line = "Press Enter to start"
    local width, height = love.window.getMode()
    local Font = love.graphics.getFont()
    local offset = Font:getWidth(line)/2
    love.graphics.print(line, width/2 - offset, height/2)
end

function Title:keyreleased(key, code)
    if key == 'return' then
        music:stop()
        Signal.emit('start')
    end
end

return Title
