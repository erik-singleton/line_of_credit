angular
  .module('login')

  .directive 'loginForm', ->
    restrict: 'E'

    scope: {}

    replace: true

    template: '''
      <div class='login-wrapper' ng-show='login.show'>
        <div class='login-form'>
          <md-toolbar class='md-accent md-hue-3'>
            <div class='md-toolbar-tools'>
              Log In / Create Account
            </div>
          </md-toolbar>
          <md-content>
            <form name="loginForm">
              <md-input-container class='md-block'>
                <label>Email</label>
                <input ng-model='login.user.email' type='text'>
              </md-input-container>
              <md-input-container class='md-block'>
                <md-button type='submit'class='md-raised md-accent md-hue-3' ng-click='login.postForm()' ng-required='true'>Login</md-button>
              </md-input-container>
            </form>
          </md-content>
        </div>
      </div>

    '''

    link: (scope, elem, attrs, ctrl) ->
      scope.$on 'event:auth-loginRequired', ->
        ctrl.show = true

      scope.$on 'event:auth-loginConfirmed', ->
        ctrl.show = false

    controller: 'LoginCtrl'

    controllerAs: 'login'
