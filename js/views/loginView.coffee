BaseView = require "./baseView.coffee"
loginTemplate = require "../templates/login.hbs"


module.exports = BaseView.extend
  template: loginTemplate
  initialize: ->
  render: ->
    @$el.html @template()