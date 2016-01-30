class Entity
  constructor: (@game, @id, @isRemote, @owner)->
    @lastState = {}

    @type = @constructor.name

    @init()

    if !@isRemote
      @onGainOwnership()

  update: ->
    return if @isRemote

    @controlledUpdate()
    @updateRemotes()

  updateRemotes: ->
    newState = @getState()
    if !_.isEqual(lastState, newState)
      @game.entityManager.broadcastEntityState(@)
      lastState = newState

  setOwned:(owned)->
    # ifhese are equal then ownership has changed
    if owned == @isRemote
      @isRemote = !owned
      if owned
        console.log("We gained ownership of #{@type} #{@id}")
        @onGainOwnership()
      else
        console.log("We lost ownership of #{@type} #{@id}")
        @onLoseOwnership()

  _getState: ->
    _.extend(@getState(), {owner: @owner})

  _setState:(state) ->
    # override to apply received state to entity

  controlledUpdate: ->
    # override to authoratively update state

  remove: ->

  init: ->

  onGainOwnership: ->

  onLoseOwnership: ->


window.Entity = Entity
