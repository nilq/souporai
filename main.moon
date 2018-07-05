export lib = require "lib"


love.graphics.setDefaultFilter "nearest", "nearest"
love.graphics.setBackgroundColor 1, 1, 1  


lib.gamestate\set "game"


math.lerp = (a, b, t) -> a + (b - a) * t
math.sign = (a)       ->
  if a < 0
    -1
  elseif a > 1
    1
  else
    0


with love
  .load   =      -> lib.gamestate\load!
  .update = (dt) -> lib.gamestate\update dt
  .draw   =      -> lib.gamestate\draw!

  .keypressed  = (key) -> lib.gamestate\press   key
  .keyreleased = (key) -> lib.gamestate\release key