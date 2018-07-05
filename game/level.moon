level = {
  size: 20 -- size of grid squares
  registry: {
    "block":  { 0, 0, 0 }
    "player": { 1, 1, 0 }
  }
  map: {}
}



objects = require "game/objects"



level.load = (path, game) =>
  image = love.image.newImageData path

  @map = {}

  for x = 1, image\getWidth!
    @map[x] = {}

    for y = 1, image\getHeight!
      rx, ry = x - 1, y - 1

      r, g, b = image\getPixel rx, ry

      for k, v in pairs level.registry
        if r == v[1] and g == v[2] and b == v[3]
          level.spawn k, level.size * rx, level.size * ry, game


level.spawn = (k, x, y, game) ->
  a = objects[k].make x, y

  game\spawn a
  game.world\add a, a.x, a.y, a.w, a.h

  a



level