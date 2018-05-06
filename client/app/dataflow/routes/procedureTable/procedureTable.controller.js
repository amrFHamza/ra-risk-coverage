'use strict';

(function(){

class ProcedureTableComponent {
  constructor($scope, Entry, $http, $state, $stateParams, $filter, $timeout) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.procedures = [];
    $scope.loadFinished = false;    

	  if ($stateParams.opcoId === undefined) {
	    $state.go('procedureTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }

		$http({
			method: 'GET',
			url: '/api/dfl-procedures/getAllProcedures',
			params: {opcoId: $stateParams.opcoId}
		}).then(function (response) {
			$scope.procedures = response.data;
			$scope.filteredProcedures = $filter('filter') ($scope.procedures, $scope.entry.searchProcedure);
			$scope.loadFinished = true;

			// Pagination in controller
			$scope.pageSize = 20;
			$scope.currentPage = 1;

		}, function (err) {

		});

		$scope.setCurrentPage = function(currentPage) {
		    $scope.currentPage = currentPage;
		};

		// Watch filter change
			var timer = false;
	    var timeoutFilterChange = function(newValue, oldValue){
           // remove filters with blank values
          $scope.entry.searchProcedure = _.pick($scope.entry.searchProcedure, function(value, key, object) {
            return value !== '' && value !== null;
          });

          if (_.size($scope.entry.searchProcedure) === 0) {
            delete $scope.entry.searchProcedure;
          }  

	        if(timer){
	          $timeout.cancel(timer);
	        }
	        timer = $timeout(function(){ 
						$scope.filteredProcedures = $filter('filter') ($scope.procedures, $scope.entry.searchProcedure);
						$scope.currentPage = 1;
	        }, 400);
	    };
	    $scope.$watch('entry.searchProcedure', timeoutFilterChange, true);		

    // $http.get('/api/dfl-procedures/getAllProcedures', {params: {'opcoId': $scope.entry.OPCO_ID}})
    // 	.success(function(data) {
	  //    $scope.procedures = data;
    // });

	  $scope.removeAllFilters = function () {
	    delete $scope.entry.searchProcedure;
	  };

	  $scope.removeFilter = function (element) {
	    delete $scope.entry.searchProcedure[element];
	    if (_.size($scope.entry.searchProcedure) === 0) {
	    	delete $scope.entry.searchProcedure;
	    }
	  };

	  $scope.procedureInfo = function (procedureId) {
	  	$state.go('procedureInfo', {procedureId: procedureId} );
	  };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('procedureTable', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });  	  

  }
}

angular.module('amxApp')
  .component('procedureTable', {
    templateUrl: 'app/dataflow/routes/procedureTable/procedureTable.html',
    controller: ProcedureTableComponent,
    controllerAs: 'procedureTableCtrl'
  });

})();
