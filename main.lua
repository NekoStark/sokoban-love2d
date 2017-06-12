function love.load()
    getmetatable('').__index = function(str,i) return string.sub(str,i,i) end
    love.graphics.setBackgroundColor(118, 140, 142)

    example = love.graphics.newImage("graphics/box.png")

    playerDown = love.graphics.newImage("graphics/player/player_down_2.png")
    playerUp = love.graphics.newImage("graphics/player/player_up_2.png")
    playerRight = love.graphics.newImage("graphics/player/player_right_2.png")
    playerLeft = love.graphics.newImage("graphics/player/player_left_2.png")
    box = love.graphics.newImage("graphics/box.png")
    storage = love.graphics.newImage("graphics/drop_zone.png")
    wall = love.graphics.newImage("graphics/wall.png")
    ground = love.graphics.newImage("graphics/ground.png")

    currentLevel = 1

    levels = {
      {
          {'#', '#', '#', '#', '#', '#', '#', '#'},
          {'#', '#', '#', '.', '#', '#', '#', '#'},
          {'#', '#', '#', ' ', '#', '#', '#', '#'},
          {'#', '#', '#', '$', ' ', '$', '.', '#'},
          {'#', '.', ' ', '$', 'V', '#', '#', '#'},
          {'#', '#', '#', '#', '$', '#', '#', '#'},
          {'#', '#', '#', '#', '.', '#', '#', '#'},
          {'#', '#', '#', '#', '#', '#', '#', '#'},
      },
      {
            {'#', '#', '#', '#', '#'},
            {'#', ' ', ' ', ' ', '#'},
            {'#', 'V', '$', '$', '#', ' ', '#', '#', '#'},
            {'#', ' ', '$', ' ', '#', ' ', '#', '.', '#'},
            {'#', '#', '#', ' ', '#', '#', '#', '.', '#'},
            {'#', '#', '#', ' ', ' ', ' ', ' ', '.', '#'},
            {'#', '#', ' ', ' ', ' ', '#', ' ', ' ', '#'},
            {'#', '#', ' ', ' ', ' ', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#', '#'},
      },
      {
          {'#', '#', '#', '#', '#', '#', '#', '#'},
          {'#', '#', ' ', ' ', ' ', ' ', ' ', '#', '#', '#'},
          {'#', '#', '$', '#', '#', '#', ' ', ' ', ' ', '#'},
          {'#', ' ', 'V', ' ', '$', ' ', ' ', '$', ' ', '#'},
          {'#', ' ', '.', '.', '#', ' ', '$', ' ', '#', '#'},
          {'#', '#', '.', '.', '#', ' ', ' ', ' ', '#'},
          {'#', '#', '#', '#', '#', '#', '#', '#', '#'},
      }
    }

    loadLevel()
end

function loadLevel()
  level = {}

  for y, row in ipairs(levels[currentLevel]) do
      level[y] = {}
      for x, cell in ipairs(row) do
          level[y][x] = cell
          if cell == 'V' or cell == '^' or cell == '<' or cell == '>' then
              playerX = x
              playerY = y
          end
      end
  end
end

function love.draw()
  for y, row in ipairs(level) do
      for x, cell in ipairs(row) do
          if cell == '.' or cell[2] == '.' then
            love.graphics.draw(storage, x*64, y*64)
          else
            love.graphics.draw(ground, x*64, y*64)
          end

          if cell == '#' then
            love.graphics.draw(wall, x*64, y*64)
          end

          if cell[1] == 'V' then
            love.graphics.draw(playerDown, x*64, y*64)
          end

          if cell[1] == '^' then
            love.graphics.draw(playerUp, x*64, y*64)
          end

          if cell[1] == '>' then
            love.graphics.draw(playerRight, x*64, y*64)
          end

          if cell[1] == '<' then
            love.graphics.draw(playerLeft, x*64, y*64)
          end

          if cell[1] == '$' then
            love.graphics.draw(box, x*64, y*64)
          end
      end
  end
end

function love.keypressed(key)
    if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
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

        local current = level[playerY][playerX]
        local destination = level[playerY+dy][playerX+dx]
        local beyond
        if level[playerY+2*dy] then
          beyond = level[playerY+2*dy][playerX+2*dx]
        end

        if destination == ' ' or destination == '.' then
          level[playerY+dy][playerX+dx] = playerOrientation(current, dx, dy, destination)
          level[playerY][playerX] = behindCell(current)
          playerX = playerX+dx
          playerY = playerY+dy

        elseif destination[1] == '$' and (beyond == '.' or beyond == ' ') then
          level[playerY+2*dy][playerX+2*dx] = '$'..beyond
          level[playerY+dy][playerX+dx] = playerOrientation(current, dx, dy, destination[2])
          level[playerY][playerX] = behindCell(current)
          playerX = playerX+dx
          playerY = playerY+dy

        end

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

    elseif key == 'r' then
      loadLevel()

    elseif key == 'n' then
      currentLevel = currentLevel + 1
      loadLevel()

    end
end

function playerOrientation(current, dx, dy, append)
  local result = ''
  if dx > 0 then
    result = '>'
  elseif dx < 0 then
    result = '<'
  else
    if dy > 0 then
      result = 'V'
    else
      result = '^'
    end
  end

  return result..append
end

function behindCell(player)
  if player[2] == '.' then
    return '.'
  else
    return ' '
  end
end
