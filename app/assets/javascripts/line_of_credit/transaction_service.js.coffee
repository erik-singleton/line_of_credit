angular
  .module('line-of-credit')

  .factory 'transactionService', ($http, creditLineService) ->
    create: (data) ->
      $http.post('/transactions', data).then (resp) =>
        creditLineService.get(data.credit_line_id)
