'use strict';

(function(){

class SystemTableComponent {
  constructor($scope, Entry, $http, $state, $stateParams) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.systems = [];
    $scope.loadFinished = false;

	  if ($stateParams.opcoId === undefined) {
	    $state.go('systemTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }


		$http({
			method: 'GET',
			url: '/api/dfl-datasources/getAllSystems',
			params: {opcoId: $stateParams.opcoId}
		}).then(function (response) {
			$scope.systems = response.data;
    	$scope.loadFinished = true;    	
		}, function (err) {
    	console.log(err);
		});

	  $scope.removeAllFilters = function () {
	    delete $scope.entry.searchSystem;
	  };

	  $scope.removeFilter = function (element) {
	    delete $scope.entry.searchSystem[element];
	    if (_.size($scope.entry.searchSystem) === 0) {
	    	delete $scope.entry.searchSystem;
	    }
	  };

	  $scope.systemInfo = function (systemId) {
	  	$state.go('systemInfo', {systemId: systemId} );
	  };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('systemTable', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });  	 
  }
}

angular.module('amxApp')
  .component('systemTable', {
    templateUrl: 'app/dataflow/routes/systemTable/systemTable.html',
    controller: SystemTableComponent,
    controllerAs: 'systemTableCtrl'
  });

})();
