module.exports =
  is_logged_in: ->
    localStorage.getItem('id') && localStorage.getItem('auth_token')
  loginSuccess: (response) ->
    localStorage.setItem('id', response.id)
    localStorage.setItem('auth_token', response.auth_token)
  loginError: ->
    alert("Invalid email/password")
  logout: ->
    localStorage.removeItem('id')
    localStorage.removeItem('auth_token')