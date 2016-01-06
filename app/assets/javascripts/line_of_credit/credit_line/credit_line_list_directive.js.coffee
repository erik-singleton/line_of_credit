angular
  .module('line-of-credit')

  .directive 'creditLineList', ->
    restrict: 'E'

    scope: {}

    template: '''
      <md-content>
        <md-list>
          <md-subheader class='md-sticky'>Available Credit Lines</md-subheader>
          <md-list-item class='md-3-line' ng-repeat='line in credit.creditLineService.data track by line.id'>
            <a ui-sref='creditLine({ id: line.id })' class='md-list-item-text single-credit-line' layout='row' layout-align='space-around center'>
              <div layout='row' align='start start' flex='33' layout-padding>
                <h3><span class='light-text'>Description:</span> {{ line.description || 'None' }}</h3>
              </div>
              <div layout='row' align='start start' flex='33' layout-padding>
                <h4><span class='light-text'>Balance:</span> {{ line.balance | currency }}</h4>
              </div>
              <div layout='column' flex='34'>
                <div layout='row'>
                  <h4><span class='light-text'><strong>Limit:</strong></span> {{ line.limit | currency }}</h4>
                </div>
                <div layout='row'>
                  <h4><span class='light-text'><strong>APR:</strong></span> {{ line.rate }}</h4>
                </div>
              </div>
            </a>
          </md-list-item>
        </md-list>
        <div layout='row' layout-align='center center' layout-padding>
          <md-button class='md-primary md-raised' ng-click='credit.createCreditLine()'>Create New Credit Line</md-button>
        </div>
      </md-content>
    '''

    controller: class CreditLineCtrl
      constructor: (@$scope, @$mdDialog, @creditLineService) ->

      submitCreditLine: ->
        @creditLineService.create(
          description: @description,
          rate: @rate,
          limit: @limit
        ).then( =>
          @$mdDialog.hide()
        )

      hideDialog: (ev) ->
        @$mdDialog.hide()

      createCreditLine: (ev) ->
        @$mdDialog.show(
          scope: @$scope,
          preserveScope: true,
          clickOutsideToClose: true,
          targetEvent: ev,
          template: '''
            <md-dialog>
              <md-dialog-content layout='column' layout-padding>
                <form name='creditLineForm'>
                  <md-input-container class='md-block'>
                    <label>Description</label>
                    <textarea ng-model='credit.description' md-maxlength='150' row='5' columns='1'></textarea>
                  </md-input-container>
                  <div layout='row' layout-align='space-around center'>
                    <md-input-container class='md-block'>
                      <label>APR</label>
                      <input ng-model='credit.rate' required type='number' step='0.1' min='0', max='100' ng-pattern='/^[0-9]{0,3}\.?[0-9]{2}?/'>
                    </md-input-container>
                    <md-input-container class='md-block'>
                      <label>Limit</label>
                      <input ng-model='credit.limit' required type='number' step='100' min='0', max='10000' ng-pattern='/^[0-9]{0,5}\.?[0-9]{2}?/'>
                    </md-input-container>
                  </div>
                </form>
              </md-dialog-content>
              <md-dialog-actions layout='row'>
                <md-button class='md-raised' ng-click='credit.hideDialog()'>Cancel</md-button>
                <md-button class='md-primary md-raised' ng-click='credit.submitCreditLine()'>Create</md-button>
              </md-dialog-actions>
            </md-dialog>
          '''
        )

    controllerAs: 'credit'
