Signal = require 'lib/signal'

local Complete = {}

function Complete:enter(from)
    self.from = from
end

function Complete:draw()
    self.from:draw()
    local line = "Level Completed! Push Enter to continue"
    local width, height = love.window.getMode()
    local Font = love.graphics.getFont()
    local offset = Font:getWidth(line)/2

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 0, 70)
    love.graphics.rectangle('fill', width/2 - (offset * 2), height/2 - 50, offset * 4, 100)
    love.graphics.setColor(r, g, b, a)

    love.graphics.print(line, width/2 - offset, height/2)
end

function Complete:keyreleased(key, code)
    if key == 'return' then
        Signal.emit('next')
    end
end

return Complete
