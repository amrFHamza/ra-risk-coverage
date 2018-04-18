'use strict';

(function(){

class DatasourceInfoComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
  	$scope.datasource = {};
  	$scope.interfaces = [];
  	$scope.datasource.links = [];

	  $scope.updateInterfaces = function() {
			// Get interfaces
			$http({
				method: 'GET',
				url: '/api/dfl-datasources/getInterfacesByType',
				params: {opcoId: $scope.datasource.OPCO_ID, type: $scope.datasource.TYPE}
			}).then(function (response) {
				$scope.interfaces = response.data;
    		
    		// update elastic fields
		    setTimeout (function () {
		      $scope.$broadcast('elastic:adjust');
		    }, 500); 

			}, function (err) {
				// handle error
				console.log(err);
			});		  	
	  };

	  if ($stateParams.datasourceId === undefined) {
	    $state.go('datasourceTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }
	  else if ($stateParams.datasourceId.substr(0,1) === 'M') {
			var queryParamsArray = $stateParams.datasourceId.split('-');
			var metricId = queryParamsArray[1];
			var opcoId = queryParamsArray[2];
			$state.go('metricInfo', {opcoId: opcoId, metricId: metricId});
	  }
	  else if ($stateParams.datasourceId === 'newDBObject') {
	  	$scope.datasource.TYPE = 'D';
	  	$scope.datasource.TYPE_TEXT = 'DB Object';
	  	$scope.datasource.STATUS_CODE = 'A';
	  	$scope.datasource.OPCO_ID = $scope.entry.currentUser.userOpcoId; 	  	
			$scope.updateInterfaces();
	  }
	  else if ($stateParams.datasourceId === 'newFile') {
	  	$scope.datasource.TYPE = 'F';
	  	$scope.datasource.TYPE_TEXT = 'File';
	  	$scope.datasource.STATUS_CODE = 'A';
	  	$scope.datasource.OPCO_ID = $scope.entry.currentUser.userOpcoId;
			$scope.updateInterfaces();
	  }
		else if ($stateParams.datasourceId === 'newEmail') {
	  	$scope.datasource.TYPE = 'E';
	  	$scope.datasource.TYPE_TEXT = 'Email';
	  	$scope.datasource.STATUS_CODE = 'A';
	  	$scope.datasource.OPCO_ID = $scope.entry.currentUser.userOpcoId;  		  	
			$scope.updateInterfaces();
	  }	  
	  else {  	
			$http({
				method: 'GET',
				url: '/api/dfl-datasources/getDatasource',
				params: {datasourceId: $stateParams.datasourceId}
			}).then(function (response) {
				$scope.datasource = response.data;
				// If interface is from another OPCO, switch selected opco and disable editing
				if (Number($scope.datasource.OPCO_ID) !== $scope.entry.currentUser.userOpcoId) {
					$scope.entry.OPCO_ID = Number($scope.datasource.OPCO_ID);
					$scope.isDisabled = $scope.entry.isDisabled();
				}					
				$scope.updateInterfaces();

				// Get linked procedures
				$http({
					method: 'GET',
					url: '/api/dfl-datasources/getLinkedProcedures',
					params: {datasourceId: $stateParams.datasourceId, getDirection: 'A'}
				}).then(function (response) {
					$scope.datasource.links = response.data;					
				}, function (err) {
					// handle error
					console.log(err);
				});

			}, function (err) {
				// handle error
				console.log(err);
			});
	  }

		$scope.save = function() {
			if (!$scope.datoForm.$valid) {
	       Entry.showToast('Please enter all required fields!');
			}
			else {
				$http({
					method: 'POST',
					url: '/api/dfl-datasources/saveDatasource',
					data: $scope.datasource
				}).then(function (response) {
					if (response.data.success) {	
						Entry.showToast('All changes saved!');
						$state.go('datasourceTable', {opcoId: $scope.datasource.OPCO_ID});
					}
					else {
							if (response.data.error.code === 'ER_DUP_ENTRY') {
								Entry.showToast('Save failed!.  Datasource with the same name and type already exists');
							}
							else {
								Entry.showToast('Save failed!.  Error ' + JSON.stringify(response.data.error));
							}
					}

				}, function (err) {
					console.log(err);
				});		
			}
		};

		$scope.cancel = function() {
			$state.go('datasourceTable', {opcoId: $scope.datasource.OPCO_ID});			
		};

		$scope.clone = function(){
			$scope.datasource.NAME = $scope.datasource.NAME + '_Clone';
			delete $scope.datasource.DATASOURCE_ID;
			$scope.datasource.links = [];
		};

		$scope.delete = function() {

      ConfirmModal('Are you sure you want to delete datasource "' + $scope.datasource.NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
					$http({
						method: 'DELETE',
						url: '/api/dfl-datasources/deleteDatasource',
						params: {datasourceId: $stateParams.datasourceId}
					}).then(function (response) {
						if (response.data.success) {	
							Entry.showToast('Datasource deleted!');
							$state.go('datasourceTable', {opcoId: $scope.datasource.OPCO_ID});			
						}
						else {
							Entry.showToast('Delete failed!.  Error ' + JSON.stringify(response.data.error));
						}				
					}, function (err) {
						// handle error
						console.log(err);
					});
				}
      })
      .catch(function(err) {
            Entry.showToast('Delete action canceled');
      });   

		};

		$scope.normalizeName = function(){
			$scope.datasource.NAME = $scope.datasource.NAME && $scope.datasource.NAME.replace(' ', '_');
		};

	    //Datepickers
	    $scope.dp = {};
	    $scope.dp.status = {opened: false};

	    $scope.dp.open = function($event) {
	      $scope.dp.status.opened = true;
	    };

	    $scope.dp.dateOptions = {
	      formatYear: 'yyyy',
	      startingDay: 1
	    };
	    
	    $scope.dp1 = {};
	    $scope.dp1.status = {opened: false};

	    $scope.dp1.open = function($event) {
	      $scope.dp1.status.opened = true;
	    };

	    $scope.dp1.dateOptions = {
	      formatYear: 'yyyy',
	      startingDay: 1
	    };
	    //Datepickers 

  }
}

angular.module('amxApp')
  .component('datasourceInfo', {
    templateUrl: 'app/dataflow/routes/datasourceInfo/datasourceInfo.html',
    controller: DatasourceInfoComponent,
    controllerAs: 'datasourceInfoCtrl'
  });

})();
