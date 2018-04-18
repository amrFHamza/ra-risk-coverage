'use strict';

(function(){

class InterfaceTableComponent {
  constructor($scope, Entry, $http, $state, $stateParams) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.interfaces = [];
    $scope.loadFinished = false;

	  if ($stateParams.opcoId === undefined) {
	    $state.go('interfaceTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }


		$http({
			method: 'GET',
			url: '/api/dfl-datasources/getAllInterfaces',
			params: {opcoId: $stateParams.opcoId}
		}).then(function (response) {
			$scope.interfaces = response.data;
    	$scope.loadFinished = true;

		}, function (err) {

		});

	  $scope.removeAllFilters = function () {
	    delete $scope.entry.searchInterface;
	  };

	  $scope.removeFilter = function (element) {
	    delete $scope.entry.searchInterface[element];
	    if (_.size($scope.entry.searchInterface) === 0) {
	    	delete $scope.entry.searchInterface;
	    }
	  };

	  $scope.interfaceInfo = function (interfaceId) {
	  	$state.go('interfaceInfo', {interfaceId: interfaceId} );
	  };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('interfaceTable', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });  	 
  }
}

angular.module('amxApp')
  .component('interfaceTable', {
    templateUrl: 'app/dataflow/routes/interfaceTable/interfaceTable.html',
    controller: InterfaceTableComponent,
    controllerAs: 'interfaceTableCtrl'
  });

})();
