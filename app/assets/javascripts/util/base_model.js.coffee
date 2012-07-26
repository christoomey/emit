class Emit.Util.BaseModel extends Backbone.Model
  randomInt: (lower, upper=0) ->
    start = Math.random()
    if not lower?
      [lower, upper] = [0, lower]
    if lower > upper
      [lower, upper] = [upper, lower]
    return Math.floor(start * (upper - lower + 1) + lower)

  randPolarity: => if @randomInt(1) is 1 then 1 else -1

  updatePos: ->
    model = this.model
    model.cacheShapePosition()
    model.positionUpdateTimeout = setTimeout model.updatePos, 200

  cacheShapePosition: =>
    pos = @shape.getPosition()
    [@x, @y] = [pos.x, pos.y]

  cancelPositionUpdate: =>
    model = this.model
    model.cacheShapePosition()
    clearTimeout model.positionUpdateTimeout

  removeInteractor: ->
    shape = this # can't seem to fix the scope!?!?
    model = shape.model # Emitter, attractor, etc

  defineShape: =>
    shape = new Kinetic.Circle
      x: @x
      y: @y
      fill: @color
      stroke: "#fff"
      strokeWidth: @strokeWidth
      draggable: true
      radius: @radius
    shape.on "dragstart", @updatePos
    shape.on "dragend", @cancelPositionUpdate
    shape.model = this
    return shape

  draw: (ctx) =>
    ctx.fillStyle = @color
    ctx.beginPath()
    [startAngle, endAngle] = [0, Math.PI * 2]
    clockwise = false
    ctx.arc @x, @y, @radius, startAngle, endAngle, clockwise
    ctx.fill()
