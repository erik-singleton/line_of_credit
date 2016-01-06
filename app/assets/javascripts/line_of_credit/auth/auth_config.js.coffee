angular
  .module('auth')

  .config ($httpProvider) ->
    $httpProvider.interceptors.push ($rootScope, $q, authBuffer) ->
      {
        responseError: (rejection) ->
          unless rejection.config.ignoreAuthModule
            switch rejection.status
              when 401
                deferred = $q.defer()
                authBuffer.append(rejection.config, deferred)
                
                $rootScope.$broadcast('event:auth-loginRequired', rejection)

                return deferred.promise
              when 403
                $rootScope.$broadcast('event:auth-forbidden', rejection)

          $q.reject(rejection)
      }
