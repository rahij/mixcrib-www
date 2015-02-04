$ = require "jquery"
BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
navProfileTemplate = require '../templates/navProfile.hbs'

module.exports = BaseView.extend
  template: navProfileTemplate
  initialize: ->
  render: ->
    AuthHelper.setAuthentication()
    model = @model
    template = @template
    el = @$el
    @model.fetch
      success: ->
        el.html template({ user: model.toJSON() })