local World = {
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','#','.','#','#','#','#'},
    {'#','#','#',' ','#','#','#','#'},
    {'#','#','#','$',' ','$','.','#'},
    {'#','.',' ','$','@','#','#','#'},
    {'#','#','#','#','$','#','#','#'},
    {'#','#','#','#','.','#','#','#'},
    {'#','#','#','#','#','#','#','#'}
  },
  {
    {'#','#','#','#','#','#','#','#','#'},
    {'#',' ',' ',' ','#','#','#','#','#'},
    {'#','@','$','$','#',' ','#','#','#'},
    {'#',' ','$',' ','#',' ','#','.','#'},
    {'#','#','#',' ','#','#','#','.','#'},
    {'#','#','#',' ',' ',' ',' ','.','#'},
    {'#','#',' ',' ',' ','#',' ',' ','#'},
    {'#','#',' ',' ',' ','#','#','#','#'},
    {'#','#','#','#','#','#','#','#','#'},
  },
  {
    {'#','#','#','#','#','#','#','#','#','#'},
    {'#','#',' ',' ',' ',' ',' ','#','#','#'},
    {'#','#','$','#','#','#',' ',' ',' ','#'},
    {'#',' ','@',' ','$',' ',' ','$',' ','#'},
    {'#',' ','.','.','#',' ','$',' ','#','#'},
    {'#','#','.','.','#',' ',' ',' ','#','#'},
    {'#','#','#','#','#','#','#','#','#','#'},
  },
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','#','#',' ',' ','.','#'},
    {'#',' ',' ',' ','$',' ','$.','#'},
    {'#',' ','$','$',' ','$','.','#'},
    {'#','#','@','#','#','.','.','#'},
    {'#','#','#','#','#','#','#','#'}
  },
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','@',' ','#','#','#','#'},
    {'#','#',' ','$',' ',' ','#','#'},
    {'#','#','#',' ','#',' ','#','#'},
    {'#','.','#',' ','#',' ',' ','#'},
    {'#','.','$',' ',' ','#',' ','#'},
    {'#','.',' ',' ',' ','$',' ','#'},
    {'#','#','#','#','#','#','#','#'}
  },
  {
    {'#','#','#','#','#','#','#','#','#','#'},
    {'#','#','#','#',' ',' ','#',' ','@','#'},
    {'#','#','#',' ',' ',' ','#',' ',' ','#'},
    {'#','#','#','$',' ','$',' ','$',' ','#'},
    {'#','#','#',' ','$','#','#',' ',' ','#'},
    {'#','#','#',' ','$',' ','#',' ','#','#'},
    {'#','.','.','.','.','.',' ',' ','#','#'},
    {'#','#','#','#','#','#','#','#','#','#'}
  },
  {
    {'#','#','#','#','#','#','#','#','#','#'},
    {'#','#','#','#',' ',' ',' ',' ','#','#'},
    {'#','#','.',' ','$','#','#',' ','#','#'},
    {'#','.','.','$',' ','$',' ',' ','@','#'},
    {'#','.','.',' ','$',' ','$',' ','#','#'},
    {'#','#','#','#','#','#',' ',' ','#','#'},
    {'#','#','#','#','#','#','#','#','#','#'},
  },
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','#',' ',' ',' ',' ','#'},
    {'#','#','#','$','$','$',' ','#'},
    {'#','@',' ','$','.','.',' ','#'},
    {'#',' ','$','.','.','.','#','#'},
    {'#','#','#','#',' ',' ','#','#'},
    {'#','#','#','#','#','#','#','#'},
  },
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','#','.','.','#','#','#'},
    {'#','#','#',' ','.','#','#','#'},
    {'#','#',' ',' ','$','.','#','#'},
    {'#','#',' ','$',' ',' ','#','#'},
    {'#',' ',' ','#','$','$',' ','#'},
    {'#',' ',' ','@',' ',' ',' ','#'},
    {'#','#','#','#','#','#','#','#'},
  },
  {
    {'#','#','#','#','#','#','#','#'},
    {'#','#','#',' ',' ','@','#','#'},
    {'#',' ',' ','$','.',' ','#','#'},
    {'#',' ',' ','.','$','.',' ','#'},
    {'#','#','#',' ','$.','$',' ','#'},
    {'#','#','#',' ',' ',' ','#','#'},
    {'#','#','#','#','#','#','#','#'},
  }
}

function World:init()
  love.graphics.setBackgroundColor(118, 140, 142)
end

function World:loadAssets(image)
  box = love.graphics.newQuad(6*64, 0, 64, 64, image:getDimensions())
  boxPlaced = love.graphics.newQuad(6*64, 1*64, 64, 64, image:getDimensions())
  storage = love.graphics.newQuad(11*64, 7*64, 64, 64, image:getDimensions())
  wall = love.graphics.newQuad(6*64, 7*64, 64, 64, image:getDimensions())
  ground = love.graphics.newQuad(11*64, 6*64, 64, 64, image:getDimensions())

  return box, boxPlaced, storage, wall, ground
end

return World
