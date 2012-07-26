class Emit.Models.Emitter extends Emit.Util.BaseModel
  constructor: (@x, @y, @worldWidth, @worldHeight) ->
    @radius = 12
    @strokeWidth = 3
    @color = "#D1C408"
    @shape = @defineShape()
    @resetCounter()

  resetCounter: =>
    @emissionCounter = @randomInt 2
    @ticks = 0

  emit: =>
    return unless @ticks++ > @emissionCounter
    @trigger 'emit', new Emit.Models.Particle @x, @y, @worldWidth, @worldHeight
    @resetCounter()
