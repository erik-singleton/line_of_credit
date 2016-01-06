angular
  .module('auth')

  .factory 'authBuffer', ($injector) ->
    buffer = []
    $http = null

    retryHttpRequest = (config, deferred) ->
      $http ?= $injector.get('$http')
      $http(config).then(
        (response) ->
          deferred.resolve(response)

        (error) ->
          deferred.reject(error)
      )

    {
      append: (config, deferred) ->
        buffer.push(config: config, deferred: deferred)

      rejectAll: (reason) ->
        if reason
          buff.deferred.reject(reason) for buff in buffer

        buffer = []

      retryAll: (updater) ->
        retryHttpRequest(updater(buff.config), buff.deferred) for buff in buffer

        buffer = []
    }
