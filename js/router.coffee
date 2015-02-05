$ = require "jquery"
NavProfileView = require "./views/navProfileView.coffee"
LoginView = require "./views/loginView.coffee"
AuthHelper = require "./helpers/auth.coffee"
User = require './models/user.coffee'

module.exports =  Backbone.Router.extend
  initialize: ->

  routes:
    "": "index"
    "music": "music"
    "login": "login"
    "logout": "logout"

  index: ->
    @navigate("music", {trigger : true})

  music: ->
    if AuthHelper.isLoggedIn()
      currentUser = new User({id: AuthHelper.getUserId()})
      global.MixcribApp.views.navProfile.model = currentUser
      global.MixcribApp.views.navProfile.setElement('#nav-profile')
      global.MixcribApp.views.navProfile.render()
    else
      global.MixcribApp.views.loginLinks.render()
      @navigate("login", {trigger : true})

  login: ->
    if AuthHelper.isLoggedIn()
      @navigate("music", {trigger : true})
    global.MixcribApp.views.login.setElement('#content')
    global.MixcribApp.views.login.render()

  logout: ->
    AuthHelper.logout()
    global.MixcribApp.views.navProfile.close()
    global.MixcribApp.views.loginLinks.render()
    @navigate("", {trigger: true})
