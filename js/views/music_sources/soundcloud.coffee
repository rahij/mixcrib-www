MusicSourceView = require "./base.coffee"
soundcloud = require "common-soundcloud"

module.exports = MusicSourceView.extend
  initialize: (args) ->
    @player = new soundcloud(args['container'])
  play: ->
    _player = @player
    @player.on 'ready', ->
      if _player.player? # temporary hack until soundcloud fixes their shit (or maybe it's me)
        _player.play()
  pause: ->
    @player.pause()
  clear: ->
    @player.destroy()