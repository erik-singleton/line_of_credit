angular
  .module('auth')

  .factory 'authService', ($rootScope, authBuffer) ->

    loginConfirmed: (data, configUpdater) ->
      updater = configUpdater || (config) -> config
      $rootScope.$broadcast('event:auth-loginConfirmed', data)
      authBuffer.retryAll(updater)

    loginCancelled: (data, reason) ->
      authBuffer.rejectAll(reason)
      $rootScope.$broadcast('event:auth-loginCancelled', data)
