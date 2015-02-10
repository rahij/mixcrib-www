$ = require "jquery"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
ViewTransitionsHelper = require "../helpers/viewTransitions.coffee"
Playlist = require "../models/playlist.coffee"
playlistTemplate = require "../templates/playlist.hbs"

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