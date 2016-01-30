#= require Network
#= require Controller
#= require EntityManager
#= require LoadState
#= require LobbyState
#= require SoccerState

MS = window.MusicalSacrifice

class BootState extends Phaser.State
  init:->
    @game.stage.disableVisibilityChange = true
    @game.stage.backgroundColor = 0x886666;
    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @game.scale.pageAlignVertically = true
    @game.scale.pageAlignHorizontally = true
    @game.state.add("Load", MS.LoadState)
    @game.state.add("Lobby", MS.LobbyState)
    @game.state.add("Soccer", MS.SoccerState)
    @game.generator = new Phaser.RandomDataGenerator([(new Date()).getTime()])

  create:->
    @game.controller = new MS.Controller(@game)
    @game.network = new MS.Network
    @game.network.on "ready", =>
      @game.entityManager = new MS.EntityManager(@game)
      @game.state.start("Load")

MS.BootState = BootState
