module.exports =
  afterLogin: ->
    global.MixcribApp.views.loginLinks.close()
    global.MixcribApp.views.login.close()
  afterLogout: ->
    global.MixcribApp.views.navProfile.close()
    global.MixcribApp.views.loginLinks.render()
  beforePlaylist: ->
    global.MixcribApp.views.newPlaylist.close()
    global.MixcribApp.views.playlist.close()