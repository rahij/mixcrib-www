$ = require "jquery"
io = require "socket.io-client"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
ViewTransitionsHelper = require "../helpers/viewTransitions.coffee"
Playlist = require "../models/playlist.coffee"
playlistTemplate = require "../templates/playlist.hbs"
SpotifyRemoteClient = require "../libs/spotify_remote_client.js"
SoundCloud = require "common-soundcloud"
youtube = require "youtube-iframe-player"

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
        $('#player').html trackTemplate({track: {'identifier': trackIdentifier}})
        player = new SoundCloud("soundcloud-player")
        # @currentStopMethod = player.destroy.bind(player)
        @currentStopMethod = false
      when 'youtube'
        trackTemplate = require "../templates/players/youtube.hbs"
        $('#player').html trackTemplate()
        youtube.init ->
          onPlayerStateChange = (event) ->
            console.log event
          youtubePlayer = youtube.createPlayer("yt-player",
            width: "720"
            height: "405"
            videoId: trackIdentifier
            playerVars:
              autoplay: 1
              controls: 0
            events:
              onStateChange: onPlayerStateChange
          )
        @currentStopMethod = false


  stopCurrentTrack: ->
    @currentStopMethod()
