$ = require "jquery"
NavProfileView = require "./views/navProfileView.coffee"
LoginView = require "./views/loginView.coffee"
AuthHelper = require "./helpers/auth.coffee"

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
    if AuthHelper.is_logged_in()
      console.log("do something")
      # navProfileView = new NavProfileView({model: })
    else
      @navigate("login", {trigger : true})

  login: ->
    new LoginView({el: '#content'}).render()

  logout: ->
    AuthHelper.logout()
    @navigate("index", {trigger: true})

