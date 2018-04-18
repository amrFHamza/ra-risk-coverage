'use strict';

(function(){

class SchedulerTableComponent {
 constructor($scope, Entry, $http, $state, $timeout, $filter, $stateParams) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.schedulers = [];
    $scope.loadFinished = false;

	  if ($stateParams.opcoId === undefined) {
	    $state.go('schedulerTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }


		$http({
			method: 'GET',
			url: '/api/dfl-procedures/getAllSchedulers',
			params: {opcoId: $stateParams.opcoId}
		}).then(function (response) {
			$scope.schedulers = response.data;
    	$scope.loadFinished = true;

		}, function (err) {

		});

		// Watch filter change
			var timer = false;
	    var timeoutFilterChange = function(newValue, oldValue){
           // remove filters with blank values
          $scope.entry.searchScheduler = _.pick($scope.entry.searchScheduler, function(value, key, object) {
            return value !== '' && value !== null;
          });

          if (_.size($scope.entry.searchScheduler) === 0) {
            delete $scope.entry.searchScheduler;
          }  

	        if(timer){
	          $timeout.cancel(timer);
	        }
	        timer = $timeout(function(){ 
						$scope.filteredSchedulers = $filter('filter') ($scope.schedulers, $scope.entry.searchScheduler);
						$scope.currentPage = 1;
	        }, 400);
	    };
	    $scope.$watch('entry.searchScheduler', timeoutFilterChange, true);

	  $scope.removeAllFilters = function () {
	    delete $scope.entry.searchScheduler;
	  };

	  $scope.removeFilter = function (element) {
	    delete $scope.entry.searchScheduler[element];

	    if (_.size($scope.entry.searchScheduler) === 0) {
	    	delete $scope.entry.searchScheduler;
	    }

	  };

	  $scope.schedulerInfo = function (schedulerId) {
	  	$state.go('schedulerInfo', {schedulerId: schedulerId} );
	  };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('schedulerTable', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });  	 
  }	
}

angular.module('amxApp')
  .component('schedulerTable', {
    templateUrl: 'app/dataflow/routes/schedulerTable/schedulerTable.html',
    controller: SchedulerTableComponent,
    controllerAs: 'schedulerTableCtrl'
  });

})();
