"use strict"
$ = require "jquery"

Mixcrib = ->
  @Config = require "./config.coffee"
  @Views =
    NavProfile: require "./views/navProfileView.coffee"
    Login: require "./views/loginView.coffee"
    LoginLinks: require "./views/loginLinksView.coffee"
  @beforeInit = ->

  @afterInit = ->

  @init = ((initData) ->
    @beforeInit.apply this  if typeof (@beforeInit) is "function"
    @views =
      navProfile: new M.Views.NavProfile()
      login: new M.Views.Login()
      loginLinks: new M.Views.LoginLinks({el: '#nav-profile'})
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