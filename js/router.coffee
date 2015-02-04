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
      new NavProfileView({ model: currentUser, el: '#nav-profile' }).render()
    else
      @navigate("login", {trigger : true})

  login: ->
    if AuthHelper.isLoggedIn()
      @navigate("music", {trigger : true})
    new LoginView({el: '#content'}).render()

  logout: ->
    AuthHelper.logout()
    @navigate("index", {trigger: true})
