angular
  .module('login')

  .directive 'logoutButton', ($state, loginService) ->
    restrict: 'E'

    scope: {}

    template: '''
      <md-button ng-click='logout()'>Log Out</md-button>
    '''

    link: (scope, elem, attrs) ->
      scope.logout = ->
        loginService.logout().then ->
          $state.go('index')

