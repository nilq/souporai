make = (x, y) ->

  player = {
    :x, :y

    w: 20             -- width
    h: 20             -- height

    dx: 0             -- delta x, velocity x
    dy: 0             -- delta y, velocity y

    frcx: 7           -- friction x
    frcy: 3           -- friction y

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

    dy_lerp_zero: false
    
    jump_hold:    false
    jump_hold_time: 2
    original_jump_hold_time: 2

    running: false
    can_run: false
    run_acc: 3

    a: 0
  }

  player.update = (dt) =>
    if @running
      @a += dt * 75
    else
      @a += dt * 20

    @gravity = math.lerp @gravity, @gravity_og, dt * 3

    if @wall_x ~= 0
      @gravity = @gravity_og

    @grounded = false
    @wall_x   = 0

    if @dy_lerp_zero
      @dy = math.lerp @dy, 0, dt * 20

      @dy_lerp_zero = false if @dy < 0.01

    if @jump_hold
      @jump_hold_time -= dt

      if @jump_hold_time <= 0
        @jump_hold      = false
        @jump_hold_time = @original_jump_hold_time

    @x, @y, @collisions = game.world\move @, @x + @dx, @y + @dy

    for c in *@collisions
      c.other\trigger @ if c.other.trigger      

      if c.normal.y ~= 0
        if c.normal.y == -1
          @grounded = true
          @can_run  = true

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
        if @running
          @dx += @acc * @run_acc * dt
        else
          @dx += @acc * dt

      if .isDown "a"
        if @running
          @dx -= @acc * @run_acc * dt
        else
          @dx -= @acc * dt

      if .isDown "lshift"
        @running = true if @can_run


    if @grounded
      @dx = math.lerp @dx, 0, @frcx * dt
    else
      @dx = math.lerp @dx, 0, @frcy * dt


    if @jump_hold
      @dy = math.lerp @dy, 0, @frcy / (100 * @jump_hold_time) * dt
    else
      @dy = math.lerp @dy, 0, @frcy * dt

    @jumped = @dy < 0

    @camera_follow dt * 4

    a = math.sign @dx

    @dir_x = -a if a ~= 0


  player.draw = =>
    sprite = game.sprites.player
    width  = sprite\getWidth!
    height = sprite\getHeight!

    rot = 0

    if @dx^2 > 0.5 and @grounded
      rot = -@dir_x * 0.075 * math.sin @a

    with love.graphics
      .setColor 1, 1, 1
      .draw sprite, @x + width / 2, @y + height / 2, rot, @dir_x, 1, width / 2, height / 2


  player.press = (key) =>
    if key == "space"
      if @grounded
        @dy        = -@jump
        @jumped    = true
        @jump_hold = true

        if @wall_x ~= 0
          @jump_hold_time = 100

      else if @wall_x ~= 0

        if @running
          @dy     = -@jump * @wall_fy
          @dx     = @jump  * @wall_fx * @wall_x * 2
        else
          @dy     = -@jump * @wall_fy
          @dx     = @jump  * @wall_fx * @wall_x

        @jumped = true

        @wall_x = 0

  player.camera_follow = (t) =>
    with game.camera
      .x = math.lerp .x, (@x + @dx * 20) * .sx, t
      .y = math.lerp .y, (@y + @dy * 2) * .sy, t

      .r = math.lerp .r, 0, t * .75


  player.release = (key) =>
    if @jumped
      if key == "space" 
        @dy_lerp_zero = true
        @jump_hold    = false
    
    if @running
      if key == "lshift"
        @running = false


  player

{
  :make
}