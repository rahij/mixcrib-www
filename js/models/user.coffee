BaseModel = require "./base.coffee"
module.exports = BaseModel.extend
  urlRoot: global.MixcribApp.Config.apiUrl + 'users'