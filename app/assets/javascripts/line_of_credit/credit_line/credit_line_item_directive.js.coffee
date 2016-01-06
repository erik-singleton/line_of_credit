angular
  .module('line-of-credit')

  .directive 'creditLineItem', ->
    restrict: 'E'

    scope: {}

    template: '''
      <md-content>
        <md-list>
          <md-subheader class='md-sticky'>Credit Line #{{ line.creditLineService.data.id }}: {{ line.creditLineService.data.description || 'Description' }}</md-subheader>
          <md-list-item class='md-3-line' ng-repeat='transaction in line.creditLineService.data.transactions | orderBy: "created_at" : true track by transaction.id'>
            <div class='md-list-item-text single-credit-line' layout='row' layout-align='space-around center'>
              <div layout='row' layout-align='start start' flex='25' layout-padding>
                <h3><span class='light-text'>{{ transaction.created_at | date : 'MM/dd/yyyy' : 'UTC' }}</span></h3>
              </div>
              <div layout='row' layout-align='start start' flex='25' layout-padding>
                <h3><span class='light-text'>Memo:</span> {{ transaction.memo || 'None' }}</h3>
              </div>
              <div layout='row' layout-align='start start' flex='25' layout-padding>
                <h4><span class='light-text'>Amount:</span> <span ng-class='{ "negative-currency": transaction.amount < 0 }'>{{ transaction.amount | currency }}</span></h4>
              </div>
              <div layout='column' flex='25'>
                <div layout='row'>
                  <h4><span class='light-text'><strong>Balance:</strong></span> {{ transaction.balance | currency }}</h4>
                </div>
              </div>
            </div>
          </md-list-item>
        </md-list>
        <div layout='row' layout-align='center center'>
          <md-button class='md-raised md-primary' ng-click='line.calculateInterest()'>Calculate Interest</md-button>
          <md-button class='md-raised' ng-click='line.createTransaction()'>New Transaction</md-button>
        </div>
      </md-content>
    '''

    controller: class CreditLineCtrl
      constructor: (@$scope, @$mdDialog, @creditLineService, @transactionService) ->
        currentDate = new Date()
        @minDate = new Date(
          currentDate.getFullYear(),
          currentDate.getMonth(),
          1
        )
        @maxDate = new Date(
          currentDate.getFullYear(),
          currentDate.getMonth()+1,
          0
        )

      calculateInterest: ->
        @creditLineService.calculateInterest()

      submitTransaction: ->
        @transactionService.create(
          credit_line_id: @creditLineService.data.id,
          memo: @memo,
          amount: @amount,
          created_at: @date.toJSON()
        ).then(
          =>
            @$mdDialog.hide()
          (error) =>
            @error = true
        )

      hideDialog: (ev) ->
        @$mdDialog.hide()

      createTransaction: (ev) ->
        @$mdDialog.show(
          scope: @$scope,
          preserveScope: true,
          clickOutsideToClose: true,
          targetEvent: ev,
          template: '''
            <md-dialog>
              <md-dialog-content layout-padding>
                <form name='transactionForm'>
                  <p ng-show='line.error' class='error-message'>Error: Invalid Input</p>
                  <md-input-container class='md-block'>
                    <label>Memo</label>
                    <textarea ng-model='line.memo' md-maxlength='150' row='5' columns='1'></textarea>
                  </md-input-container>
                  <div layout='column' layout-align='space-around stretch'>
                    <md-input-container class='md-block'>
                      <label>Amount</label>
                      <input ng-model='line.amount' required type='number' step='1' min='-10000', max='10000' ng-pattern='/^[0-9]{0,5}\.?[0-9]{2}?/'>
                    </md-input-container>
                    <md-datepicker ng-model='line.date' md-placeholder='Enter date'
                        md-min-date='line.minDate' md-max-date='line.maxDate'></md-datepicker>
                  </div>
                </form>
              </md-dialog-content>
              <md-dialog-actions layout='row'>
                <md-button class='md-raised' ng-click='line.hideDialog()'>Cancel</md-button>
                <md-button class='md-primary md-raised' ng-click='line.submitTransaction()'>Create</md-button>
              </md-dialog-actions>
            </md-dialog>
          '''
        )

    controllerAs: 'line'
