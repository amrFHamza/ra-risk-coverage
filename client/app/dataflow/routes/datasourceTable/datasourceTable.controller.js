'use strict';

(function(){

class DatasourceTableComponent {
  constructor($scope, Entry, $http, $state, $stateParams, $filter, $timeout) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.datasources = [];
    $scope.loadFinished = false;

	  if ($stateParams.opcoId === undefined) {
	    $state.go('datasourceTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }

		$http({
			method: 'GET',
			url: '/api/dfl-datasources/getAllDatasources',
			params: {opcoId: $stateParams.opcoId}
		}).then(function (response) {
			$scope.datasources = response.data;

			$scope.filteredDatasources = $filter('filter') ($scope.datasources, $scope.entry.searchDatasource);

			// Pagination in controller
			$scope.pageSize = 25;
			$scope.currentPage = 1;
			$scope.setCurrentPage = function(currentPage) {
			    $scope.currentPage = currentPage;
			};
			// Pagination in controller

			$scope.loadFinished = true;

		}, function (err) {

		});

		// Watch filter change
			var timer = false;
	    var timeoutFilterChange = function(newValue, oldValue){

           // remove filters with blank values
          $scope.entry.searchDatasource = _.pick($scope.entry.searchDatasource, function(value, key, object) {
            return value !== '' && value !== null;
          });

          if (_.size($scope.entry.searchDatasource) === 0) {
            delete $scope.entry.searchDatasource;
          }  
	    	
	        if(timer){
	          $timeout.cancel(timer);
	        }
	        timer = $timeout(function(){ 

						$scope.filteredDatasources = $filter('filter') ($scope.datasources, $scope.entry.searchDatasource);

						// Pagination in controller
						$scope.currentPage = 1;
						$scope.setCurrentPage = function(currentPage) {
						    $scope.currentPage = currentPage;
						};
						// Pagination in controller

	        }, 400);
	    };
	    $scope.$watch('entry.searchDatasource', timeoutFilterChange, true);		

	  $scope.removeAllFilters = function () {
	    delete $scope.entry.searchDatasource;
	  };

	  $scope.removeFilter = function (element) {
	    delete $scope.entry.searchDatasource[element];
	    if (_.size($scope.entry.searchDatasource) === 0) {
	    	delete $scope.entry.searchDatasource;
	    }
	  };

	  $scope.datasourceInfo = function (datasourceId) {
	  	$state.go('datasourceInfo', {datasourceId: datasourceId} );
	  };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('datasourceTable', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });  	  
  }
}

angular.module('amxApp')
  .component('datasourceTable', {
    templateUrl: 'app/dataflow/routes/datasourceTable/datasourceTable.html',
    controller: DatasourceTableComponent,
    controllerAs: 'datasourceTableCtrl'
  });

})();
