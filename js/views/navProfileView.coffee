BaseView = require "./baseView.coffee"
AuthHelper = require "../helpers/auth.coffee"
navProfileTemplate = require '../templates/navProfile.hbs'

module.exports = BaseView.extend
  template: navProfileTemplate
  initialize: ->
  render: ->
    model = @model
    template = @template
    el = @$el
    @model.fetch(
      data:
        auth: AuthHelper.getAuthOptions()
      success: ->
        el.html template({ user: model.toJSON() })
    )