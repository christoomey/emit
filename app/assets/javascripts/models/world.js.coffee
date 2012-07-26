class Emit.Models.World extends Emit.Util.BaseModel
  constructor: ->
    @margin = 0
    [@height, @width] = @windowDims()
    @emitters = []
    @particles = []
    @interactors = []
    @initEmitters()
    @initInteractors()
    @count = 0
    @gravity = 0.01 # m^3 / (kg * s^2)
    @stage = @createStage()
    @backgroundLayer = @createBackgroundLayer()
    @interactorsLayer = @initInteractorsLayer()
    @particlesLayer = new Kinetic.Layer()
    @addEmitters()
    @addLayersToStage()
    @stage.onFrame @update
    @stage.start()

  initEmitters: =>
    for i in [1..1]
      padding = 5
      x = @randomInt(@width - padding, @margin + padding)
      y = @randomInt(@height - padding, @margin + padding)
      emitter = new Emit.Models.Emitter x, y, @width, @height
      emitter.on 'emit', @addParticle
      @emitters.push emitter

  initInteractors: =>
    for i in [1..3]
      padding = 5
      x = @randomInt(@width - padding, @margin + padding)
      y = @randomInt(@height - padding, @margin + padding)
      attractor = new Emit.Models.Attractor x, y, @width, @height
      @interactors.push attractor

  createBackgroundLayer: =>
    layer = new Kinetic.Layer()
    rectConfig =
      x: 0
      y: 0
      height: @height
      width: @width
      fill: "#444"
    rect = new Kinetic.Rect rectConfig
    layer.add rect
    return layer

  initInteractorsLayer: =>
    layer = new Kinetic.Layer
    interactorsAndEmitters = _.flatten([@emitters, @interactors])
    _.each interactorsAndEmitters, (player) => layer.add player.shape
    return layer

  addEmitters: => _.each @emitters, (emitter) => @interactorsLayer.add emitter.shape

  addLayersToStage: =>
    layers = [@backgroundLayer, @interactorsLayer, @particlesLayer]
    _.each layers, (layer) => @stage.add layer

  windowDims: =>
    height = window.innerHeight - (@margin * 2)
    width = window.innerWidth - (@margin * 2)
    return [height, width]

  createStage: =>
    stageSettings =
      container: "container"
      width: window.innerWidth
      height: window.innerHeight
    return new Kinetic.Stage stageSettings

  addParticle: (particle) =>
    particle.on "outOfBounds", @removeParticle
    @particles.push particle
    @particlesLayer.add particle.shape

  removeParticle: (particle) =>
    particle.shape.parent.remove particle.shape
    @particles = _.without(@particles, particle)

  update: (frame) =>
    emitter.emit() for emitter in @emitters
    particle.update(frame.timeDiff, @interactors) for particle in @particles
    @particlesLayer.draw()
