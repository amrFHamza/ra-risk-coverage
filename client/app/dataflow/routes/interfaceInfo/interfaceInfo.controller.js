'use strict';

(function(){

class InterfaceInfoComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
  	$scope.interface = {};
  	
	  if ($stateParams.interfaceId === undefined) {
	    $state.go('interfaceTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }
	  else if ($stateParams.interfaceId === 'new') {
	  	$scope.interface.OPCO_ID = $scope.entry.currentUser.userOpcoId; 	  	
	  	$scope.interface.INTERFACE_TYPE = 'D';
	  }  
	  else {  	
			$http({
				method: 'GET',
				url: '/api/dfl-datasources/getInterface',
				params: {interfaceId: $stateParams.interfaceId}
			}).then(function (response) {
				$scope.interface = response.data;
				// If interface is from another OPCO, switch selected opco and disable editing
				if (Number($scope.interface.OPCO_ID) !== $scope.entry.currentUser.userOpcoId) {
					$scope.entry.OPCO_ID = Number($scope.interface.OPCO_ID);
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
					url: '/api/dfl-datasources/saveInterface',
					data: $scope.interface
				}).then(function (response) {
					if (response.data.success) {	
						Entry.showToast('All changes saved!');
						$state.go('interfaceTable', {opcoId: $scope.interface.OPCO_ID});
					}
					else {
							if (response.data.error.code === 'ER_DUP_ENTRY') {
								Entry.showToast('Save failed!  Interface with the same name already exists');
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
			$state.go('interfaceTable', {opcoId: $scope.interface.OPCO_ID});			
		};

		$scope.clone = function(){
			$scope.interface.INTERFACE_NAME = $scope.interface.INTERFACE_NAME + '_Clone';
			delete $scope.interface.INTERFACE_ID;
		};

		$scope.delete = function() {

      ConfirmModal('Are you sure you want to delete interface "' + $scope.interface.INTERFACE_NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
					$http({
						method: 'DELETE',
						url: '/api/dfl-datasources/deleteInterface',
						params: {interfaceId: $stateParams.interfaceId}
					}).then(function (response) {
						if (response.data.success) {	
							Entry.showToast('Interface deleted');
							$state.go('interfaceTable', {opcoId: $scope.interface.OPCO_ID});			
						}
						else {
							Entry.showToast('Delete failed! Error ' + JSON.stringify(response.data.error));
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
  .component('interfaceInfo', {
    templateUrl: 'app/dataflow/routes/interfaceInfo/interfaceInfo.html',
    controller: InterfaceInfoComponent,
    controllerAs: 'interfaceInfoCtrl'
  });

})();
