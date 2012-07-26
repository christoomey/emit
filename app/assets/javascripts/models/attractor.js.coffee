class Emit.Models.Attractor extends Emit.Util.BaseModel
  constructor: (@x, @y, @worldWidth, @worldHeight) ->
    @radius = 8
    @strokeWidth = 2
    @polarity = @randPolarity()
    @color = @colorForPolarity()
    @mass = 50 # kg?
    @shape = @defineShape()

  colorForPolarity: => if @polarity is 1 then "green" else "red"
