class Emit.Models.Attractor extends Emit.Util.BaseModel
  constructor: (@x, @y, @worldWidth, @worldHeight) ->
    @radius = 8
    @strokeWidth = 2
    @color = "green"
    @mass = 500 # kg?
    @shape = @defineShape()
