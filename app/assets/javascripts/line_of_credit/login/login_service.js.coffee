angular
  .module('login')

  .factory 'loginService', (LoginConstants, $http) ->
    login: (options) ->
      options ?= {}
      url = options.url || LoginConstants.urls.login
      data = options.data || {}

      $http.post(url, data)

    logout: (options) ->
      options ?= {}
      url = options.url || LoginConstants.urls.logout

      $http.get(url)
