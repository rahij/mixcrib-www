$ = require "jquery"
NavProfileView = require "./views/navProfileView.coffee"
LoginView = require "./views/loginView.coffee"
AuthHelper = require "./helpers/auth.coffee"
ViewTransitionsHelper = require "./helpers/viewTransitions.coffee"

module.exports =  Backbone.Router.extend
  initialize: ->

  route: (route, name, callback) ->
    route = @_routeToRegExp(route)  unless _.isRegExp(route)
    if _.isFunction(name)
      callback = name
      name = ""
    callback = this[name]  unless callback
    router = this
    Backbone.history.route route, (fragment) ->
      args = router._extractParameters(route, fragment)
      next = ->
        callback and callback.apply(router, args)
        router.trigger.apply router, [ "route:" + name ].concat(args)
        router.trigger "route", name, args
        Backbone.history.trigger "route", router, name, args
        router.after.apply router, args

      router.before.apply router, [ args, next ]
    @

  routes:
    "": "index"
    "music": "music"
    "login": "login"
    "logout": "logout"
    "playlist/:id" : "playlist"

  requiresAuth:
    ['#music', '#playlist']

  before: (params, next) ->
    isLoggedIn = AuthHelper.isLoggedIn()
    path = Backbone.history.location.hash.split('/')[0];
    needAuth = _.contains(@requiresAuth, path);

    if needAuth && !isLoggedIn
      global.MixcribApp.views.loginLinks.render()
      @navigate("login", {trigger : true})
    else
      next()

  after: ->

  index: ->
    @navigate("music", {trigger : true})

  music: ->
    currentUser = new global.MixcribApp.Models.User({id: AuthHelper.getUserId()})
    global.MixcribApp.views.navProfile.model = currentUser
    global.MixcribApp.views.navProfile.setElement('#nav-profile')
    global.MixcribApp.views.navProfile.render()

    global.MixcribApp.views.newPlaylist.setElement('#content')
    global.MixcribApp.views.newPlaylist.render(true)

  playlist: (id)->
    global.MixcribApp.views.playlist.model = new global.MixcribApp.Models.Playlist({id: id})
    global.MixcribApp.views.playlist.setElement('#content')
    global.MixcribApp.views.playlist.render(true)

  login: ->
    if AuthHelper.isLoggedIn()
      @navigate("music", {trigger : true})
    global.MixcribApp.views.login.setElement('#content')
    global.MixcribApp.views.login.render()

  logout: ->
    AuthHelper.logout()
    ViewTransitionsHelper.afterLogout()
    @navigate("", {trigger: true})
