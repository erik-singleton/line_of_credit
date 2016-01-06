angular
  .module('line-of-credit')

  .factory 'creditLineService', ($http) ->
    get: (id) ->
      if id
        $http.get("/credit_lines/#{id}").then (resp) =>
          @data = resp.data.credit_line

      else
        $http.get('/credit_lines').then (resp) =>
          @data = resp.data

    create: (data) ->
      $http.post('/credit_lines', data).then (resp) =>
        @data.push(resp.data)

    calculateInterest: ->
      throw('Cannot calculate interest on full set of credit lines') if @data.constructor is Array
      
      $http.post('/credit_lines/interest_calculation', { id: @data.id }).then (resp) =>
        old_interest_index = @data.transactions.findIndex (transaction) ->
          transaction.id is resp.data.id

        if old_interest_index isnt -1
          @data.transactions[old_interest_index] = resp.data
        else
          @data.transactions.unshift(resp.data)
