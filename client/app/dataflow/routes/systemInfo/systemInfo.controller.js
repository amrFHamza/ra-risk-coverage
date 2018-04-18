'use strict';

(function(){

class SystemInfoComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
  	$scope.system = {};
  	
	  if ($stateParams.systemId === undefined) {
	    $state.go('systemTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }
	  else if ($stateParams.systemId === 'new') {
	  	$scope.system.OPCO_ID = $scope.entry.currentUser.userOpcoId; 	  	
	  	$scope.system.SCHEDULER_TYPE = 'D';
	  }  
	  else {  	
			$http({
				method: 'GET',
				url: '/api/dfl-datasources/getSystem',
				params: {systemId: $stateParams.systemId}
			}).then(function (response) {
				$scope.system = response.data;
				// If system is from another OPCO, switch selected opco and disable editing
				if (Number($scope.system.OPCO_ID) !== $scope.entry.currentUser.userOpcoId) {
					$scope.entry.OPCO_ID = Number($scope.system.OPCO_ID);
					$scope.isDisabled = $scope.entry.isDisabled();
				}				
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
					url: '/api/dfl-datasources/saveSystem',
					data: $scope.system
				}).then(function (response) {
					if (response.data.success) {	
						Entry.showToast('All changes saved!');
						$state.go('systemTable', {opcoId: $scope.system.OPCO_ID});
					}
					else {
							if (response.data.error.code === 'ER_DUP_ENTRY') {
								Entry.showToast('Save failed! System with the same name already exists.');
							}
							else {
								Entry.showToast('Save failed! Error ' + JSON.stringify(response.data.error));
							}
					}

				}, function (err) {
					console.log(err);
				});		
			}
		};

		$scope.cancel = function() {
			$state.go('systemTable', {opcoId: $scope.system.OPCO_ID});			
		};

		$scope.clone = function(){
			$scope.system.NAME = $scope.system.NAME + '_Clone';
			delete $scope.system.SYSTEM_ID;
		};

		$scope.delete = function() {

      ConfirmModal('Are you sure you want to delete system "' + $scope.system.NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
					$http({
						method: 'DELETE',
						url: '/api/dfl-datasources/deleteSystem',
						params: {systemId: $stateParams.systemId}
					}).then(function (response) {
						if (response.data.success) {	
							Entry.showToast('System deleted!');
							$state.go('systemTable', {opcoId: $scope.system.OPCO_ID});			
						}
						else {
							Entry.showToast('Delete failed! Error: ' + JSON.stringify(response.data.error));
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
  .component('systemInfo', {
    templateUrl: 'app/dataflow/routes/systemInfo/systemInfo.html',
    controller: SystemInfoComponent,
    controllerAs: 'systemInfoCtrl'
  });

})();
