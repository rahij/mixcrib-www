"use strict"
$ = require "jquery"

Mixcrib = ->
  @Config = require "./config.coffee"
  @beforeInit = ->

  @afterInit = ->

  @init = ((initData) ->
    @beforeInit.apply this  if typeof (@beforeInit) is "function"
    @afterInit.apply this  if typeof (@afterInit) is "function"
    return
  ).bind(this)
  return

M = new Mixcrib()
global.MixcribApp = M

$ ->
  M.init()
  Routers =
    Router : require "./router.coffee"
  M.router = new Routers.Router()
  Backbone.history.start
    pushState: true
    root: M.Config.appRoot