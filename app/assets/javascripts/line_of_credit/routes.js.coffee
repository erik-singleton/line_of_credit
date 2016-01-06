angular
  .module('line-of-credit')

  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state 'index',
        url: '/'

        resolve:
          creditLineService: (creditLineService) ->
            creditLineService.get()

        template: '<credit-line-list></credit-line-list>'

        controller: 'NoopCtrl'

      .state 'creditLine',
        url: '/credit_line/:id'

        resolve:
          creditLineService: ($stateParams, creditLineService) ->
            creditLineService.get($stateParams.id)

        template: '<credit-line-item></credit-line-item>'

        controller: 'NoopCtrl'
