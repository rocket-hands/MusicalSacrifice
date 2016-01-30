#= require Entity

class Avatar extends Entity
  constructor: ->
    super

    @sprite = @host.spriteGroup.create(-100,-100, 'nigel')
    @sprite.animations.add("down", [0, 1, 2, 1], 20, true)
    @sprite.animations.add("left", [4, 5, 6, 5], 10, true)
    @sprite.animations.add("right", [8, 9, 10, 9], 10, true)
    @sprite.animations.add("up", [12, 13, 14, 13], 20, true)
    @sprite.animations.add("idle", [1], 20, true)

    if !@isRemote
      @host.game.physics.arcade.enable(@sprite)

  setState:(state)->
    @sprite.position.x = state.x
    @sprite.position.y = state.y
    if @sprite.animations.currentAnim.name != state.anim
      @sprite.animations.play(state.anim)

  getState:(state)->
    x: @sprite.position.x,
    y: @sprite.position.y
    anim: @sprite.animations.currentAnim.name

  despawn:->
    @sprite.kill()

  controlledUpdate:->
    moves = @host.pollController()

    if (moves.left)
      @sprite.body.velocity.x = -150
    if (moves.right)
      @sprite.body.velocity.x = 150
    if (moves.up)
      @sprite.body.velocity.y = -150
    if (moves.down)
      @sprite.body.velocity.y = 150

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

    @sprite.body.velocity.x *= 0.9
    @sprite.body.velocity.y *= 0.9

window.Avatar = Avatar