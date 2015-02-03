Config = require "../config.coffee"

module.exports = Backbone.Model.extend
  url: Config.apiUrl
