'use strict';

(function(){

class RiskTableComponent {
  constructor($scope, Entry, Coverage, $filter, $timeout, $state) {
    $scope.entry = Entry;
    $scope.businessProcesses = [];
    $scope.risks = [];
    $scope.subRisks = [];
    $scope.selectedRisks = [];
    $scope._und = _;

    $scope.isDisabled = $scope.entry.isDisabled();

    Coverage.getRisks()
      .then(function(data){
        $scope.risks = data;
        $scope.businessProcesses = _.map(_.groupBy(data, 'BUSINESS_PROCESS_ID'), function(g) {
          return { 
              BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
              BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
            };
        });
    });

    Coverage.getAllSubRisks()
    	.then(function(data){
        $scope.subRisks = data;
    });

    $scope.removeAllFilters = function () {
      $scope.entry.searchRiskCatalogue = {};
    };

    $scope.removeFilter = function (element) {
      delete $scope.entry.searchRiskCatalogue[element];
      if (_.size($scope.entry.searchRiskCatalogue) === 0) {
        $scope.entry.searchRiskCatalogue = {};
      }
    };

    $scope.setFilterBusinessProcess = function (businessProcesses) {
      if (businessProcesses) {
        $scope.entry.searchRiskCatalogue.BUSINESS_PROCESS = businessProcesses;
      }
      else {
        delete $scope.entry.searchRiskCatalogue.BUSINESS_PROCESS;
      }
    };

    $scope.printSelected = function() {
      $scope.selectedRisks = _.filter($scope.risks, function(elem) { return elem.SELECTED == 'Y';});
    };

    $scope.removeSelected = function() {
      $scope.selectedRisks = _.filter($scope.risks, function(elem) { return elem.SELECTED == 'Y';});
      $scope.selectedRisks.forEach(function(r) {r.SELECTED = 'N';});
      $scope.selectedRisks = [];
    };

    $scope.riskInfo = function(riskId, subProcessId) {
      $scope.removeSelected();
      if (riskId) {
        $state.go('riskInfo', {riskId: riskId}, {reload: true});
      }
      else {
        $state.go('riskInfo', {subProcessId: subProcessId}, {reload: true});
      }
    };

    $scope.getSubRisks = function(riskId) {
      return _.filter($scope.subRisks, function(e) {return e.RISK_ID == riskId;});
    };

    // Watch filter change
    var timer = false;
    var timeoutFilterChange = function(newValue, oldValue){
        if(timer){
          $timeout.cancel(timer);
        }
        timer = $timeout(function(){ 

          // remove filters with blank values
          $scope.entry.searchRiskCatalogue = _.pick($scope.entry.searchRiskCatalogue, function(value, key, object) {
            return value !== '' && value !== null;
          });
          
          if (_.size($scope.entry.searchRiskCatalogue) === 0) {
            //delete $scope.entry.searchRiskCatalogue;
            $scope.entry.searchRiskCatalogue = {};
          }
                
          $scope.filteredRisks = $filter('filter') ($scope.risks, $scope.entry.searchRiskCatalogue);
        }, 400);
    };
    $scope.$watch('entry.searchRiskCatalogue', timeoutFilterChange, true);      

  }
}

angular.module('amxApp')
  .component('riskTable', {
    templateUrl: 'app/coverage/routes/riskTable/riskTable.html',
    controller: RiskTableComponent,
    controllerAs: 'riskTableCtrl'
  });

})();
