'use strict';

(function(){

class SchedulerInfoComponent {
constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
  	$scope.scheduler = {};
  	
	  if ($stateParams.schedulerId === undefined) {
	    $state.go('schedulerTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }
	  else if ($stateParams.schedulerId === 'new') {
	  	$scope.scheduler.OPCO_ID = $scope.entry.currentUser.userOpcoId; 	  	
	  	$scope.scheduler.SCHEDULER_TYPE = 'D';
	  }  
	  else {  	
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getScheduler',
				params: {schedulerId: $stateParams.schedulerId}
			}).then(function (response) {
				$scope.scheduler = response.data;
				// If scheduler is from another OPCO, switch selected opco and disable editing
				if (Number($scope.scheduler.OPCO_ID) !== $scope.entry.currentUser.userOpcoId) {
					$scope.entry.OPCO_ID = Number($scope.scheduler.OPCO_ID);
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
					url: '/api/dfl-procedures/saveScheduler',
					data: $scope.scheduler
				}).then(function (response) {
					if (response.data.success) {	
						Entry.showToast('All changes saved!');
						$state.go('schedulerTable', {opcoId: $scope.scheduler.OPCO_ID});
					}
					else {
							if (response.data.error.code === 'ER_DUP_ENTRY') {
								Entry.showToast('Save failed! Scheduler with the same name already exists.');
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
			$state.go('schedulerTable', {opcoId: $scope.scheduler.OPCO_ID});			
		};

		$scope.clone = function(){
			$scope.scheduler.SCHEDULER_NAME = $scope.scheduler.SCHEDULER_NAME + '_Clone';
			delete $scope.scheduler.SCHEDULER_ID;
		};

		$scope.delete = function() {

      ConfirmModal('Are you sure you want to delete scheduler "' + $scope.scheduler.SCHEDULER_NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
					$http({
						method: 'DELETE',
						url: '/api/dfl-procedures/deleteScheduler',
						params: {schedulerId: $stateParams.schedulerId}
					}).then(function (response) {
						if (response.data.success) {	
							Entry.showToast('Scheduler deleted!');
							$state.go('schedulerTable', {opcoId: $scope.scheduler.OPCO_ID});			
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
  .component('schedulerInfo', {
    templateUrl: 'app/dataflow/routes/schedulerInfo/schedulerInfo.html',
    controller: SchedulerInfoComponent,
    controllerAs: 'schedulerInfoCtrl'
  });

})();
