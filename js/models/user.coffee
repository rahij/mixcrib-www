Config = require "../config.coffee"
BaseModel = require "./base.coffee"
module.exports = BaseModel.extend
  url: Config.apiUrl + 'users'