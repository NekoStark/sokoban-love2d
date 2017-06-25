Signal = require 'lib/signal'

local Title = {}

function Title:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
end

function Title:keyreleased(key, code)
    if key == 'return' then
        Signal.emit('start')
    end
end

return Title
