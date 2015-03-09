$ = require "jquery"
io = require "socket.io-client"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
ViewTransitionsHelper = require "../helpers/viewTransitions.coffee"
Playlist = require "../models/playlist.coffee"
playlistTemplate = require "../templates/playlist.hbs"
SpotifyRemoteClient = require "../libs/spotify_remote_client.js"
SoundCloud = require "common-soundcloud"

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
    if @currentStopMethod
      @stopCurrentTrack()
    trackElement = $(e.currentTarget)
    trackIdentifier = trackElement.attr('data-track-identifier')
    service = trackElement.attr('data-track-service')

    switch service
      when 'spotify'
        trackTemplate = require "../templates/players/spotify.hbs"
        $('#player').html trackTemplate({track: {'identifier': trackIdentifier}})
        spClient = new SpotifyRemoteClient();
        spClient.init(io);
        spClient.playTrack(trackIdentifier)
        @currentStopMethod = spClient.pauseCurrentTrack.bind(spClient)
      when 'soundcloud'
        trackTemplate = require "../templates/players/soundcloud.hbs"
        SoundCloudSource = require "./music_sources/soundcloud.coffee"
        $('#player').html trackTemplate({track: {'identifier': trackIdentifier}})
        @music_source = new SoundCloudSource({container: "soundcloud-player"})
        @music_source.play()
        @currentStopMethod = @music_source.clear.bind(@music_source)
      when 'youtube'
        trackTemplate = require "../templates/players/youtube.hbs"
        YoutubeSource = require "./music_sources/youtube.coffee"
        $('#player').html trackTemplate()
        @music_source = new YoutubeSource({ container: "yt-player", trackIdentifier: trackIdentifier})
        @music_source.play()
        @currentStopMethod = @music_source.clear.bind(@music_source)


  stopCurrentTrack: ->
    @currentStopMethod()
