export lib = require "lib"


lib.gamestate\set "game"


with love
  .graphics.setBackgroundColor 1, 1, 1


  .load   =      -> lib.gamestate\load!
  .update = (dt) -> lib.gamestate\update dt
  .draw   =      -> lib.gamestate\draw!

  .keypressed  = (key) -> lib.gamestate\press   key
  .keyreleased = (key) -> lib.gamestate\release key