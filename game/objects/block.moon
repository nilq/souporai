make = (x, y) ->
  block = {
    :x, :y

    w: 32
    h: 32
  }



  block.draw = =>
    with love.graphics
      .setColor 0, 0, 0
      .rectangle "fill", @x, @y, @w, @h


  block



{
  :make
}