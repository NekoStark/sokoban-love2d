Gamestate = require 'lib/gamestate'
Signal = require 'lib/signal'

Title = require 'scenes/title'
Game = require 'scenes/game'
Complete = require 'scenes/complete'

function love.load()
  love.window.setMode(800, 600, {resizable=false})
  love.graphics.setBackgroundColor(118, 140, 142)

  Signal.register('start', function()
    Gamestate.switch(Game)
  end)

  Signal.register('completed', function()
    Gamestate.push(Complete)
  end)

  Signal.register('next', function()
    Game:next()
    Gamestate.pop()
  end)

  Gamestate.registerEvents()
  Gamestate.switch(Title)
end
