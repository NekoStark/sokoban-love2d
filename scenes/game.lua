Camera = require 'lib/camera'
anim8 = require 'lib/anim8'
Timer = require 'lib/timer'
Signal = require 'lib/signal'

World1 = require 'levels/world-1'
World2 = require 'levels/world-2'

local Game = {}

function substr(str,i)
  return string.sub(str,i,i)
end

local function loadLevel()
  -- FIXME controllare se queste variabili sono locali per questo modulo, altrimenti farle diventare (?)
  level = {}
  player = {
    animation = animations.player.down,
    position = {},
    moving = false
  }
  currentBox = {
    moving = false
  }

  for y, row in ipairs(worlds[currentWorld][currentLevel]) do
    level[y] = {}
    for x, cell in ipairs(row) do
      level[y][x] = cell
      if cell == '@' then
        player.position.x = x
        player.position.y = y
      end
    end
  end

  local height = table.getn(level)*64
  local width = table.getn(level[1])*64

  camera:lookAt(width/2,height/2)

  if height > 600 then
    camera:zoom(600/height)
  elseif height < 600 and width > 800 then
    camera:zoom(800/width)
  else
    camera:zoom(1)
  end
end

function updatePlayerOrientation(dx, dy)
  if dx > 0 then
    player.animation = animations.player.right
  elseif dx < 0 then
    player.animation = animations.player.left
  else
    if dy > 0 then
      player.animation = animations.player.down
    else
      player.animation = animations.player.up
    end
  end
end

function behindCell(p)
  if substr(p, 2) == '.' then
    return '.'
  else
    return ' '
  end
end

function checkCompletedLevel()
  local completed = true
  for testY, row in ipairs(level) do
    for testX, cell in ipairs(row) do
      if substr(cell, 1) == '$' and substr(cell, 2) ~= '.' then
        completed = false
      end
    end
  end

  if completed then
    Signal.emit('completed')
  end
end

function Game:next()
  currentLevel = currentLevel + 1
  if currentLevel > table.getn(worlds[currentWorld]) then
    currentWorld = currentWorld + 1
    if currentWorld > table.getn(worlds) then
      love.event.quit( "restart" )
    else
      currentLevel = 1
      worlds[currentWorld]:init()
      box, boxPlaced, storage, wall, ground = worlds[currentWorld]:loadAssets(image)
      loadLevel()
    end
  else
    loadLevel()
  end
end

function Game:enter()
  camera = Camera.new(0, 0)

  image = love.graphics.newImage('graphics/tilesheet.png')

  local g = anim8.newGrid(64, 64, image:getWidth(), image:getHeight(), 0, 5*64, 0)
  animations = {
    player = {
      up = anim8.newAnimation(g(5,1, 6,1), 0.4),
      down = anim8.newAnimation(g(2,1, 3,1), 0.4),
      right = anim8.newAnimation(g(1,3, 2,3), 0.4),
      left = anim8.newAnimation(g(4,3, 5,3), 0.4),
    }
  }

  currentWorld = 1
  currentLevel = 1

  worlds = { World1, World2 }

  worlds[currentWorld]:init()
  box, boxPlaced, storage, wall, ground = worlds[currentWorld]:loadAssets(image)
  loadLevel()
end

function Game:update(dt)
  player.animation:update(dt)
  Timer.update(dt)
end

function Game:draw()
  camera:attach()

  for y, row in ipairs(level) do
    for x, cell in ipairs(row) do
      local screenX = (x - 1)*64
      local screenY = (y - 1)*64

      if cell == '.' or substr(cell, 2) == '.' then
        love.graphics.draw(image, storage, screenX, screenY)
      else
        love.graphics.draw(image, ground, screenX, screenY)
      end

      if cell == '#' then
        love.graphics.draw(image, wall, screenX, screenY)
      end

      if substr(cell, 1) == '$' then
        if substr(cell, 2) == '.' then
          love.graphics.draw(image, boxPlaced, screenX, screenY)
        else
          love.graphics.draw(image, box, screenX, screenY)
        end
      end

    end
  end

  player.animation:draw(image, (player.position.x - 1)*64, (player.position.y - 1)*64)

  if currentBox.moving then
    love.graphics.draw(image, box, (currentBox.x - 1)*64, (currentBox.y - 1)*64)
  end

  camera:detach()

  love.graphics.print(camera:position(), 10, 10)
end

function Game:keypressed(key)
  if (key == 'left' or key == 'right' or key == 'up' or key == 'down') and not player.moving then
    local dx = 0
    local dy = 0
    if key == 'left' then
      dx = -1
    elseif key == 'right' then
      dx = 1
    elseif key == 'up' then
      dy = -1
    elseif key == 'down' then
      dy = 1
    end

    local current = level[player.position.y][player.position.x]
    local destination = level[player.position.y+dy][player.position.x+dx]
    local beyond
    if level[player.position.y+2*dy] then
      beyond = level[player.position.y+2*dy][player.position.x+2*dx]
    end

    if destination == ' ' or destination == '.' then
      updatePlayerOrientation(dx, dy)
      level[player.position.y][player.position.x] = behindCell(current)

      player.moving = true
      Timer.tween(0.2, player.position, {x = player.position.x+dx, y = player.position.y+dy}, 'linear', function()
        level[player.position.y][player.position.x] = '@'..destination
        player.moving = false
      end)

    elseif substr(destination, 1) == '$' and (beyond == '.' or beyond == ' ') then
      updatePlayerOrientation(dx, dy)
      currentBox = {x = player.position.x+dx, y = player.position.y+dy}
      level[player.position.y][player.position.x] = behindCell(current)
      level[player.position.y+dy][player.position.x+dx] = '@'..substr(destination, 2)

      player.moving = true
      Timer.tween(0.2, player.position, {x = player.position.x+dx, y = player.position.y+dy}, 'linear', function()
        level[player.position.y][player.position.x] = '@'..substr(destination, 2)
        player.moving = false
      end)

      currentBox.moving = true
      Timer.tween(0.2, currentBox, {x = player.position.x+2*dx, y = player.position.y+2*dy}, 'linear', function()
        level[currentBox.y][currentBox.x] = '$'..beyond
        currentBox.moving = false
        checkCompletedLevel()
      end)

    end

  elseif key == 'r' and not player.moving then
    loadLevel()

  elseif key == 'n' and not player.moving then
    Game:next()

  end
end

return Game
