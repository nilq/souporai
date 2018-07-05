game = {
  objects: {} -- game objects of the world
}



camera = require "game/camera"



game.load = =>
  @objects = {}

  @camera  = camera.make 0, 0, 2, 2, 0


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