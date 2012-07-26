class Emit.Models.Particle extends Emit.Util.BaseModel
  constructor: (@x, @y, @worldWidth, @worldHeight) ->
    @radius = 2
    @strokeWidth = 1
    @color = "white"
    @shape = @defineShape()
    @rateThrottle = 100 #30
    @xVelocity = @randomInt(10, 1) / @rateThrottle * @randPolarity() # meters / sec
    @yVelocity = @randomInt(10, 1) / @rateThrottle * @randPolarity()

  outOfBounds: =>
    return true if (@x < 0) or (@y < 0)
    return true if (@x > @worldWidth) or (@y > @worldHeight)
    return false

  # Return an array of accelerations in m/s^2 units
  accelerations: (interactors) =>
    [axs, ays] = [[],[]]
    accels = for interactor in interactors
      [dx, dy] = [(interactor.x - @x), (interactor.y - @y)]
      r = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
      a = (Emit.world.gravity * interactor.mass) / Math.pow(r, 2) * interactor.polarity
      axs.push a*(dx/r)
      ays.push a*(dy/r)
    return [axs, ays]

  updatedVelocities: (axs, ays, timeDiff) =>
    vx = @xVelocity + _.reduce axs, (memo, ax) -> memo + ax*timeDiff
    vy = @yVelocity + _.reduce ays, (memo, ay) -> memo + ay*timeDiff
    return [vx, vy]

  inAnAttractor: (interactors) =>
    for interactor in interactors
      [dx, dy] = [(interactor.x - @x), (interactor.y - @y)]
      r = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
      return true if r < (interactor.radius + 1)

  update: (timeDiff, interactors) =>
    [axs, ays] = @accelerations interactors
    [@xVelocity, @yVelocity] = @updatedVelocities axs, ays, timeDiff
    @x += @xVelocity*timeDiff
    @y += @yVelocity*timeDiff
    @shape.setPosition @x, @y
    @trigger("outOfBounds", this) if @outOfBounds()
    @trigger("outOfBounds", this) if @inAnAttractor interactors
