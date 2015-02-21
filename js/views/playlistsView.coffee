$ = require "jquery"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
Playlists = require "../collections/playlists.coffee"
playlistsTemplate = require "../templates/playlists.hbs"

module.exports = BaseView.extend
  template: playlistsTemplate
  initialize: ->
  render: ()->
    collection = @collection
    template = @template
    el = @$el
    @collection.fetch(
      data:
        auth: AuthHelper.getAuthOptions()
      success: ->
        el.html template({ playlists: collection.toJSON() })
        return @
    )