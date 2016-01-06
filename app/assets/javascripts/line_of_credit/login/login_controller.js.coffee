angular
  .module('login')

  .controller 'LoginCtrl', (loginService, authService) ->
    @postForm = =>
      loginService.login(data: { email: @user.email }).then(
        (resp) =>
          if resp.status >= 200 and resp.status <= 400
            authService.loginConfirmed()

        (rejection) =>
          if rejection.status >= 400
            @error = true
      )

    @logout = ->
      loginService.logout()

