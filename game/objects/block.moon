make = (x, y, key) ->
  block = {
    :x, :y

    w: 20
    h: 20

    :key
  }



  block.draw = =>
    with love.graphics
      .setColor 0, 0, 0

      if @key == "jump"
        .setColor 0, 1, 0
      
      if @key == "die"
        .setColor 1, 0, 0

      .rectangle "fill", @x, @y, @w, @h


  block



{
  :make
}