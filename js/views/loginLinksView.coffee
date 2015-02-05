$ = require "jquery"
BaseView = require "./baseView.coffee"
loginLinksTemplate = require '../templates/loginLinks.hbs'

module.exports = BaseView.extend
  template: loginLinksTemplate
  initialize: ->
  render: ->
    @$el.html @template()