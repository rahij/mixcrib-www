$ = require "jquery"
io = require "socket.io-client"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
ViewTransitionsHelper = require "../helpers/viewTransitions.coffee"
Playlist = require "../models/playlist.coffee"
playlistTemplate = require "../templates/playlist.hbs"
SpotifyRemoteClient = require "../libs/spotify_remote_client.js"

module.exports = BaseView.extend
  template: playlistTemplate
  initialize: ->
  render: (append = false)->
    model = @model
    template = @template
    el = @$el
    @model.fetch(
      data:
        auth: AuthHelper.getAuthOptions()
      success: ->
        if append
          el.append template({ playlist: model.toJSON() })
        else
          el.html template({ playlist: model.toJSON() })
        return @
    )
  events:
    "click .track": "playTrack"
  playTrack: (e) ->
    trackElement = $(e.currentTarget)
    trackIdentifier = trackElement.attr('data-track-identifier')
    if trackElement.attr('data-track-service') == 'spotify'
      trackTemplate = require "../templates/players/spotify.hbs"
      $('#player').html trackTemplate({track: {'identifier': trackIdentifier}})
      spClient = new SpotifyRemoteClient();
      spClient.init(io);
      spClient.playTrack(trackIdentifier)
