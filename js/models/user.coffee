Config = require "../config.coffee"
BaseModel = require "./base.coffee"
module.exports = BaseModel.extend
  urlRoot: Config.apiUrl + 'users'