Gamestate = require 'lib/gamestate'
Signal = require 'lib/signal'

Title = require 'scenes/title'
Game = require 'scenes/game'

function love.load()
  love.window.setMode(800, 600, {resizable=false})
  love.graphics.setBackgroundColor(118, 140, 142)

  Signal.register('start', function()
    Game:load()
    Gamestate.switch(Game)
  end)

  Gamestate.registerEvents()
  Gamestate.switch(Title)
end
