Camera = require 'lib/camera'
anim8 = require 'lib/anim8'
Timer = require 'lib/timer'

function love.load()
  getmetatable('').__index = function(str,i) return string.sub(str,i,i) end
  love.window.setMode(800, 600, {resizable=false})
  love.graphics.setBackgroundColor(118, 140, 142)

  camera = Camera.new(0, 0)

  image = love.graphics.newImage('graphics/tilesheet.png')

  local g = anim8.newGrid(64, 64, image:getWidth(), image:getHeight(), 0, 5*64, 0)
  player_up = anim8.newAnimation(g(5,1, 6,1), 0.4)
  player_down = anim8.newAnimation(g(2,1, 3,1), 0.4)
  player_right = anim8.newAnimation(g(1,3, 2,3), 0.4)
  player_left = anim8.newAnimation(g(4,3, 5,3), 0.4)

  player = player_down

  box = love.graphics.newQuad(6*64, 0, 64, 64, image:getDimensions())
  storage = love.graphics.newQuad(11*64, 7*64, 64, 64, image:getDimensions())
  wall = love.graphics.newQuad(6*64, 7*64, 64, 64, image:getDimensions())
  ground = love.graphics.newQuad(11*64, 6*64, 64, 64, image:getDimensions())

  currentLevel = 1

  levels = {
    {
      {'#', '#', '#', '#', '#', '#', '#', '#'},
      {'#', '#', '#', '.', '#', '#', '#', '#'},
      {'#', '#', '#', ' ', '#', '#', '#', '#'},
      {'#', '#', '#', '$', ' ', '$', '.', '#'},
      {'#', '.', ' ', '$', '@', '#', '#', '#'},
      {'#', '#', '#', '#', '$', '#', '#', '#'},
      {'#', '#', '#', '#', '.', '#', '#', '#'},
      {'#', '#', '#', '#', '#', '#', '#', '#'},
    },
    {
      {'#', '#', '#', '#', '#', '#', '#', '#', '#'},
      {'#', ' ', ' ', ' ', '#', '#', '#', '#', '#'},
      {'#', '@', '$', '$', '#', ' ', '#', '#', '#'},
      {'#', ' ', '$', ' ', '#', ' ', '#', '.', '#'},
      {'#', '#', '#', ' ', '#', '#', '#', '.', '#'},
      {'#', '#', '#', ' ', ' ', ' ', ' ', '.', '#'},
      {'#', '#', ' ', ' ', ' ', '#', ' ', ' ', '#'},
      {'#', '#', ' ', ' ', ' ', '#', '#', '#', '#'},
      {'#', '#', '#', '#', '#', '#', '#', '#', '#'},
    },
    {
      {'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
      {'#', '#', ' ', ' ', ' ', ' ', ' ', '#', '#', '#'},
      {'#', '#', '$', '#', '#', '#', ' ', ' ', ' ', '#'},
      {'#', ' ', '@', ' ', '$', ' ', ' ', '$', ' ', '#'},
      {'#', ' ', '.', '.', '#', ' ', '$', ' ', '#', '#'},
      {'#', '#', '.', '.', '#', ' ', ' ', ' ', '#', '#'},
      {'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'},
    }
  }

  loadLevel()
end

function loadLevel()
  level = {}
  playerPosition = {moving = false}
  currentBox = {moving = false}

  for y, row in ipairs(levels[currentLevel]) do
    level[y] = {}
    for x, cell in ipairs(row) do
      level[y][x] = cell
      if cell == '@' then
        playerPosition.x = x
        playerPosition.y = y
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

function love.update(dt)
  player:update(dt)
  Timer.update(dt)
end

function love.draw()
  camera:attach()

  for y, row in ipairs(level) do
    for x, cell in ipairs(row) do
      local screenX = (x - 1)*64
      local screenY = (y - 1)*64

      if cell == '.' or cell[2] == '.' then
        love.graphics.draw(image, storage, screenX, screenY)
      else
        love.graphics.draw(image, ground, screenX, screenY)
      end

      if cell == '#' then
        love.graphics.draw(image, wall, screenX, screenY)
      end

      if cell[1] == '$' then
        love.graphics.draw(image, box, screenX, screenY)
      end
    end
  end

  player:draw(image, (playerPosition.x - 1)*64, (playerPosition.y - 1)*64)

  if currentBox.x and currentBox.y then
    love.graphics.draw(image, box, (currentBox.x - 1)*64, (currentBox.y - 1)*64)
  end

  camera:detach()

  love.graphics.print(camera:position(), 10, 10)
end

function love.keypressed(key)
  if (key == 'left' or key == 'right' or key == 'up' or key == 'down') and not playerPosition.moving then
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

    local current = level[playerPosition.y][playerPosition.x]
    local destination = level[playerPosition.y+dy][playerPosition.x+dx]
    local beyond
    if level[playerPosition.y+2*dy] then
      beyond = level[playerPosition.y+2*dy][playerPosition.x+2*dx]
    end

    if destination == ' ' or destination == '.' then
      updatePlayerOrientation(dx, dy)
      level[playerPosition.y][playerPosition.x] = behindCell(current)

      playerPosition.moving = true
      Timer.tween(0.2, playerPosition, {x = playerPosition.x+dx, y = playerPosition.y+dy}, 'linear', function()
        level[playerPosition.y][playerPosition.x] = '@'..destination
        playerPosition.moving = false
        checkCompletedLevel()
      end)

    elseif destination[1] == '$' and (beyond == '.' or beyond == ' ') then
      updatePlayerOrientation(dx, dy)
      currentBox = {x = playerPosition.x+dx, y = playerPosition.y+dy, moving = true}
      level[playerPosition.y][playerPosition.x] = behindCell(current)
      level[playerPosition.y+dy][playerPosition.x+dx] = '@'..destination[2]

      Timer.tween(0.2, currentBox, {x = playerPosition.x+2*dx, y = playerPosition.y+2*dy}, 'linear', function()
        level[currentBox.y][currentBox.x] = '$'..beyond
        currentBox = {moving = false}
      end)

      playerPosition.moving = true
      Timer.tween(0.2, playerPosition, {x = playerPosition.x+dx, y = playerPosition.y+dy}, 'linear', function()
        level[playerPosition.y][playerPosition.x] = '@'..destination
        playerPosition.moving = false
        checkCompletedLevel()
      end)

    end

  elseif key == 'r' then
    loadLevel()

  elseif key == 'n' then
    currentLevel = currentLevel + 1
    loadLevel()

  end
end

function updatePlayerOrientation(dx, dy)
  if dx > 0 then
    player = player_right
  elseif dx < 0 then
    player = player_left
  else
    if dy > 0 then
      player = player_down
    else
      player = player_up
    end
  end
end

function behindCell(player)
  if player[2] == '.' then
    return '.'
  else
    return ' '
  end
end

function checkCompletedLevel()
  local completed = true
  for testY, row in ipairs(level) do
    for testX, cell in ipairs(row) do
      if cell[1] == '$' and cell[2] ~= '.' then
        completed = false
        break
      end
      if completed == false then
        break
      end
    end
  end

  if completed then
    currentLevel = currentLevel + 1
    if currentLevel > table.getn(levels) then
      love.event.quit( "restart" )
    else
      loadLevel()
    end
  end
end
