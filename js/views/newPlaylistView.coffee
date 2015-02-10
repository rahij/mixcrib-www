$ = require "jquery"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
ViewTransitionsHelper = require "../helpers/viewTransitions.coffee"
newPlaylistFormTemplate = require "../templates/newPlaylistForm.hbs"
Playlist = require "../models/playlist.coffee"

module.exports = BaseView.extend
  template: newPlaylistFormTemplate
  initialize: ->
  render: (append = false)->
    if append
      @$el.append @template()
    else
      @$el.html @template()
    return @

  events:
    "submit #new-playlist-form" : "submitNewPlaylistForm"

  submitNewPlaylistForm: (e) ->
    e.preventDefault()
    newPlaylist = new Playlist()
    newPlaylist.save {
        auth: AuthHelper.getAuthOptions()
        name: $('#new-playlist-form #name').val()
      },
      success: (response) ->
        console.log response