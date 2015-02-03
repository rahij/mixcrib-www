fs = require "fs"
$ = require "jquery"

module.exports = Backbone.View.extend

  template: null #in actual files use something like below:
  #template: fs.readFileSync "#{__dirname}/../templates/patient-list-template.ejs", "utf8"