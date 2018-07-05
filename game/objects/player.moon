make = (x, y) ->

  player = {
    :x, :y

    w: 20             -- width
    h: 20             -- height

    dx: 0             -- delta x, velocity x
    dy: 0             -- delta y, velocity y

    frcx: 7           -- friction x
    frcy: 4           -- friction y

    acc: 15           -- acceleration

    jump:   10.5      -- jump force
    jumped: false     -- did the player jump

    grounded: false   -- is the player on the ground

    gravity:    45    -- modified gravity ..
    gravity_og: 45    -- constantly lerping towards original gravity

    wall_x: 0         -- -1: touching left wall, 0: not touching, 1: touching right wall

    wall_fx: .7       -- horizontal wall jump force, multiplied with the jump force
    wall_fy: .735     -- vertical jump force

    dir_x: 1          -- horizontal direction, for sprite drawing

    dash_timer: .25   -- time threshold between dash button presses
    dash_x: 0         -- horizontal dash direction, like `wall_x`
  }

  player.update = (dt) =>
    @gravity = math.lerp @gravity, @gravity_og, dt * 3

    if @wall_x ~= 0
      @gravity = @gravity_og

    @grounded = false
    @wall_x    = 0

    @x, @y, @collisions = game.world\move @, @x + @dx, @y + @dy

    for c in *@collisions
      c.other\trigger @ if c.other.trigger      

      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true

        @dy = 0

      if c.normal.x ~= 0
        unless @grounded and @wall_x ~= 0
          @gravity /= 1.25
          @dx -= c.normal.x * .5 * dt

        @dx = 0

        @wall_x = c.normal.x
    
    @trigger_flag = false

    if @jumped
      @gravity -= 1.5 * dt


    -- apply gravity
    @dy += @gravity * dt

    with love.keyboard
      if .isDown "d"
        @dx += @acc * dt

      if .isDown "a"
        @dx -= @acc * dt


    if @grounded
      @dx = math.lerp @dx, 0, @frcx * dt
    else
      @dx = math.lerp @dx, 0, @frcy * dt


    @dy = math.lerp @dy, 0, @frcy * dt

    @jumped = @dy < 0

    @camera_follow dt * 4


    a = math.sign @dx

    @dir_x = -a if a ~= 0


    if @dash_x ~= 0
      if @dash_timer > 0
        @dash_timer -= dt
      elseif @dash_timer < 0
        @dash_x = 0
        @dash_timer = .25


  player.draw = =>
    sprite = game.sprites.player
    width  = sprite\getWidth!

    with love.graphics
      .setColor 1, 1, 1
      .draw sprite, @x + width / 2, @y, 0, @dir_x, 1, width / 2


  player.press = (key) =>
    if key == "space"
      if @grounded
        @dy     = -@jump
        @jumped = true
      else if @wall_x ~= 0
        @dy     = -@jump * @wall_fy
        @dx     = @jump  * @wall_fx * @wall_x

        @jumped = true

        @wall_x = 0
    

    if key == "d"
      if @dash_x == 1
        @dx = @jump
        @dash_x = 0
      else
        @dash_x = 1

    if key == "a"
      if @dash_x == -1
        @dx = -@jump
        @dash_x = 0
      else
        @dash_x = -1


  player.camera_follow = (t) =>
    with game.camera
      .x = math.lerp .x, (@x + @dx * 20) * .sx, t
      .y = math.lerp .y, (@y + @dy * 2) * .sy, t

      .r = math.lerp .r, 0, t * .75


  player.release = (key) =>
    if @jumped
      if key == "space" 
        @dy = 0


  player

{
  :make
}