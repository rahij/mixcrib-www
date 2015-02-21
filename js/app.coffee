"use strict"
$ = require "jquery"
AuthHelper = require "./helpers/auth.coffee"

Mixcrib = ->
  @Config = require "./config.coffee"
  @Collections =
    Playlists: require "./collections/playlists.coffee"
  @Models =
    User: require "./models/user.coffee"
    Playlist: require "./models/playlist.coffee"
  @Views =
    NavProfile: require "./views/navProfileView.coffee"
    Login: require "./views/loginView.coffee"
    LoginLinks: require "./views/loginLinksView.coffee"
    NewPlaylist: require "./views/newPlaylistView.coffee"
    Playlist: require "./views/playlistView.coffee"
    Playlists: require "./views/playlistsView.coffee"
  @beforeInit = ->

  @afterInit = ->
    M.views.playlists.setElement('#sidebar')
    M.views.playlists.render()

    currentUser = new global.MixcribApp.Models.User({id: AuthHelper.getUserId()})
    global.MixcribApp.views.navProfile.model = currentUser
    global.MixcribApp.views.navProfile.setElement('#nav-profile')
    global.MixcribApp.views.navProfile.render()
  @init = ((initData) ->
    @beforeInit.apply this  if typeof (@beforeInit) is "function"
    @views =
      navProfile: new M.Views.NavProfile()
      login: new M.Views.Login()
      loginLinks: new M.Views.LoginLinks({el: '#nav-profile'})
      newPlaylist: new M.Views.NewPlaylist()
      playlist: new M.Views.Playlist()
      playlists: new M.Views.Playlists({collection: new M.Collections.Playlists()})
    @afterInit.apply this  if typeof (@afterInit) is "function"
    return
  ).bind(this)
  return

M = new Mixcrib()
global.MixcribApp = M

$ ->
  M.init()
  Routers =
    Router : require "./router.coffee"
  M.router = new Routers.Router()

  Backbone.history.start
    root: M.Config.appRoot