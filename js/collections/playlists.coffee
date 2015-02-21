BaseCollection = require "./base.coffee"
Config = require "../config.coffee"
Playlist = require "../models/playlist.coffee"
module.exports = BaseCollection.extend
  model: Playlist
  url: Config.apiUrl + 'playlists'