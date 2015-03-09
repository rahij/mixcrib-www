#  Common music source interface. Any new music source must extend this class
#  and implement these methods
BaseView = require "../baseView.coffee"
module.exports = BaseView.extend
  initialize: ->
    throw "Subclass responsibly"
  play: ->
    throw "Subclass responsibly"
  pause: ->
    throw "Subclass responsibly"
  clear: ->
    throw "Subclass responsibly"
