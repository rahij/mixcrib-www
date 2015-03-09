MusicSourceView = require "./base.coffee"
youtube = require "youtube-iframe-player"

module.exports = MusicSourceView.extend
  initialize: (args) ->
    @youtubePlayer = null
    @playerReady = false
    _this = @
    youtube.init ->
      _this.youtubePlayer = youtube.createPlayer(args['container'],
        width: "720"
        height: "405"
        videoId: args['trackIdentifier']
        playerVars:
          autoplay: 0
          controls: 1
        events:
          onReady: -> _this.playerReady = true
      )
  play: ->
    _this = @
    poll = setInterval((->
      if _this.playerReady
        clearInterval poll
        _this.youtubePlayer.playVideo()
      return
      ), 500)
  pause: ->
    @youtubePlayer.pauseVideo()
  clear: ->
    @youtubePlayer.clearVideo()