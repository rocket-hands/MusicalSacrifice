#= require Entity

class Avatar extends Entity
  ACCELERATION = 600
  MAX_SPEED = 200
  DRAG = 200

  init: ->
    @movement =
      acceleration: new Phaser.Point
      max_velocity: new Phaser.Point

    @setSprite()

    if !@isRemote
      @game.physics.arcade.enable(@sprite)
      @sprite.body.drag.set(DRAG, DRAG)
      @sprite.body.collideWorldBounds = true
      @sprite.body.bounce.set(0.7,0.7)

  setSprite: ->
    @skin = @game.generator.pick(@game.sheets)
    row = @game.generator.pick([0, 1])
    col = @game.generator.pick([0, 1, 2, 3])
    @sprite = @game.entityManager.group.create(-100,-100, @skin)
    top = row*48 + col*3
    @sprite.animations.add("idle", [top + 1], 10, true)
    @sprite.animations.add("down", [top, top+1, top+2], 10, true)
    top += 12
    @sprite.animations.add("left", [top, top+1, top+2], 10, true)
    top += 12
    @sprite.animations.add("right", [top, top+1, top+2], 10, true)
    top += 12
    @sprite.animations.add("up", [top, top+1, top+2], 10, true)
    @sprite.animations.play("idle")
    @sprite.scale.set(2, 2)

  setState:(state)->
    @sprite.position.x = state.x
    @sprite.position.y = state.y
    if @sprite.animations.currentAnim.name != state.anim
      @sprite.animations.play(state.anim)
    if state.skin && @skin != state.skin
      @skin = state.skin
      @sprite.loadTexture(@skin)

  getState:(state)->
    x: @sprite.position.x,
    y: @sprite.position.y,
    skin: @skin,
    anim: @sprite.animations.currentAnim.name

  remove:->
    @sprite.kill()

  controlledUpdate:->
    moves = @game.controller.poll()

    @movement.acceleration.set(0, 0)
    @movement.max_velocity.set(MAX_SPEED, MAX_SPEED)
    if (moves.left)
      @movement.acceleration.x = -1
    if (moves.right)
      @movement.acceleration.x = 1
    if (moves.up)
      @movement.acceleration.y = -1
    if (moves.down)
      @movement.acceleration.y = 1
    @movement.acceleration.setMagnitude(ACCELERATION)
    @sprite.body.acceleration = @movement.acceleration
    if @sprite.body.velocity.getMagnitude() > MAX_SPEED
      @movement.max_velocity.setMagnitude(MAX_SPEED)
    @sprite.body.maxVelocity = @movement.max_velocity

    anim = "idle"
    if Math.abs(@sprite.body.velocity.x) > Math.abs(@sprite.body.velocity.y)
      if @sprite.body.velocity.x > 25
        anim = "right"
      else if @sprite.body.velocity.x < -25
        anim = "left"
    else
      if @sprite.body.velocity.y > 25
        anim = "down"
      else if @sprite.body.velocity.y < -25
        anim = "up"
    if @sprite.animations.currentAnim.name != anim
      @sprite.animations.play(anim)

window.Avatar = Avatar
