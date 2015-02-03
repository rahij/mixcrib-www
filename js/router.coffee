$ = require "jquery"
NavProfileView = require "./views/navProfileView.coffee"
LoginView = require "./views/loginView.coffee"

module.exports =  Backbone.Router.extend
  initialize: ->

  routes:
    "": "index"
    "music": "music"
    "login": "login"

  index: ->
    @navigate("music", {trigger : true})

  music: ->
    console.log("rendering music")
    if localStorage.getItem('id') && localStorage.getItem('auth_token')
      console.log("do something")
      # navProfileView = new NavProfileView({model: })
    else
      @navigate("login", {trigger : true})

  login: ->
    new LoginView({el: '#content'}).render()

