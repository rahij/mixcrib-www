$ = require "jquery"
BaseView = require "./baseView.coffee"
loginTemplate = require "../templates/login.hbs"
AuthHelper = require "../helpers/auth.coffee"

module.exports = BaseView.extend
  template: loginTemplate
  initialize: ->
  render: ->
    @$el.html @template()
    return @

  events:
    "submit #login-form" : "submitLoginForm"

  submitLoginForm: (e) ->
    e.preventDefault()
    $.ajax
      type: 'GET'
      url: global.MixcribApp.Config.apiUrl + 'users/auth'
      data: @$("#login-form").serialize()
      success: (response) ->
        AuthHelper.loginSuccess(response)
        global.MixcribApp.views.loginLinks.close()
        global.MixcribApp.views.login.close()
        global.MixcribApp.router.navigate("music", {trigger: true})
      error: -> AuthHelper.loginError()