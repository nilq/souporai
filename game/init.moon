game = {
  objects: {} -- game objects of the world
}



camera = require "game/camera"
level  = require "game/level"



game.spawn = (object) =>
  @objects[#@objects + 1] = object


game.load = =>
  @objects = {}

  @camera  = camera.make 0, 0, 0, 0, 0
  @world   = lib.bump.newWorld!


  level\load "res/levels/0.png", @


game.update = (dt) =>
  for object in *@objects
    object\update dt if object.update


game.draw = =>
  @camera\set!


  for object in *@objects
    object\draw! if object.draw


  @camera\unset!


game.press = (key) =>
  for object in *@objects
    object\press key if object.press


game.release = (key) =>
  for object in *@objects
    object\release key if object.release



game