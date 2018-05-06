'use strict';

(function(){

class MeasureTableComponent {
  constructor($scope, Entry, Coverage, $filter, $timeout, $state) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    
    $scope.businessProcesses = [];
    $scope.measures = [];
    $scope.subRisks = [];
    $scope.selectedRisks = [];
    $scope._und = _;
    $scope.loadFinished = false;

    // Pagination
    $scope.pageSize = 20;
    $scope.currentPage = 1;

    $scope.setCurrentPage = function(currentPage) {
        $scope.currentPage = currentPage;
    };

    Coverage.getMeasures()
      .then(function(data){
        $scope.measures = data;
        $scope.businessProcesses = _.map(_.groupBy(data, 'BUSINESS_PROCESS_ID'), function(g) {
          return { 
              BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
              BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
            };
        });
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
      $scope.selectedRisks = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});
    };

    $scope.removeSelected = function() {
      $scope.selectedMeasures = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});
      $scope.selectedMeasures.forEach(function(r) {r.SELECTED = 'N';});
      $scope.selectedMeasures = [];
    };

    $scope.measureInfo = function(measureId) {
      $scope.removeSelected();
      if (measureId) {
        $state.go('measureInfo', {measureId: measureId}, {reload: true});
      }
    };

    // Watch filter change
    var timer = false;
    var timeoutFilterChange = function(newValue, oldValue){
        if(timer){
          $timeout.cancel(timer);
        }
        timer = $timeout(function(){ 

          $scope.loadFinished = false;
          // remove filters with blank values
          $scope.entry.searchRiskCatalogue = _.pick($scope.entry.searchRiskCatalogue, function(value, key, object) {
            return value !== '' && value !== null;
          });
          
          if (_.size($scope.entry.searchRiskCatalogue) === 0) {
            //delete $scope.entry.searchRiskCatalogue;
            $scope.entry.searchRiskCatalogue = {};
          }
                
          $scope.filteredMeasures = $filter('filter') ($scope.measures, $scope.entry.searchRiskCatalogue);
          $scope.loadFinished = true;
          $scope.currentPage = 1;

        }, 400);
    };
    $scope.$watch('entry.searchRiskCatalogue', timeoutFilterChange, true);      

  }
}

angular.module('amxApp')
  .component('measureTable', {
    templateUrl: 'app/coverage/routes/measureTable/measureTable.html',
    controller: MeasureTableComponent,
    controllerAs: 'measureTableCtrl'
  });

})();
