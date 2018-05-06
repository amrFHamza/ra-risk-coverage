'use strict';

(function(){

class MeasureInfoComponent {
  constructor($scope, Entry, Coverage, $state, $stateParams, ConfirmModal, $sce) {
    $scope.entry = Entry;
  	$scope.measure = {};
  	$scope.subRisks = [];
  	$scope.processes = [];
  	$scope.measures = [];
  	$scope.subProcesses = [];
    $scope.isDisabled = Entry.isDisabled();

	  if ($stateParams.measureId === undefined || $stateParams.measureId === 'newMeasure') {
	  	Coverage.getProcesses().then(function(data) {
	  		$scope.processes = data;
	  	});

		 	Coverage.getSubProcesses().then(function(data) {
		  	$scope.subProcesses = data;
  				if ($stateParams.subProcessId) {
		  			$scope.measure = angular.copy(_.find(data, function(e) {return e.BUSINESS_SUB_PROCESS_ID == $stateParams.subProcessId;}));
  				}
		  });
		  $scope.measure.RELEVANT = 'Y';
	  }
	  else {
	  	Coverage.getMeasureInfo($stateParams.measureId).then(function(data) {
	  		$scope.measure = data;
	  	});

	  	Coverage.getProcesses().then(function(data) {
	  		$scope.processes = data;
	  	});

		 	Coverage.getSubProcesses().then(function(data) {
		  	$scope.subProcesses = data;
		  });
	  }

  	$scope.processChanged = function(processId) {
  		// $scope.subRisks = [];
			$scope.measure.BUSINESS_PROCESS_ID =  angular.copy(_.find($scope.processes, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_PROCESS_ID;
			$scope.measure.BUSINESS_PROCESS =  angular.copy(_.find($scope.processes, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_PROCESS;
			$scope.measure.BUSINESS_SUB_PROCESS_ID =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_SUB_PROCESS_ID;
			$scope.measure.BUSINESS_SUB_PROCESS =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_SUB_PROCESS;			
  	};

  	$scope.subProcessChanged = function(subProcessId) {
  		// $scope.subRisks = [];
			$scope.measure.BUSINESS_SUB_PROCESS_ID =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_SUB_PROCESS_ID === subProcessId;})).BUSINESS_SUB_PROCESS_ID;
			$scope.measure.BUSINESS_SUB_PROCESS =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_SUB_PROCESS_ID === subProcessId;})).BUSINESS_SUB_PROCESS;
  	};

		$scope.save = function() {
			if (!$scope.datoForm.$valid) {
	       Entry.showToast('Please enter all required fields!');
			}
			else if (!$scope.datoForm.$dirty) {
	      Entry.showToast('No unsaved changes. Nothing to save.');
				// $state.go('riskTable', {});
			}
			else {
				Coverage.postMeasure({measure: $scope.measure}).then(function(response) {
					if (response.success) {	
						Entry.showToast('All changes saved!');
						$scope.datoForm.$setPristine();
						if (response.MEASURE_ID) {
							$state.go('measureInfo', {measureId: response.MEASURE_ID});
						}
						else {
							$state.go('measureInfo', {measureId: $stateParams.measureId});
						}
						// $state.go('riskTable', {});
					}
					else {
						Entry.showToast('Save failed! Error ' + JSON.stringify(response.error));
					}
				});
			}
		};

		$scope.cancel = function() {
			$state.go('measureTable', {});			
		};

		$scope.deleteMeasure = function(measureId) {
      ConfirmModal('Are you sure you want to delete measure "' + $scope.measure.MEASURE_NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
        	Coverage.deleteMeasure(measureId).then(function(response){
						if (response.success) {	
		          Entry.showToast('Measure deleted. All changes saved!');
							$state.go('measureTable', {});
						}
						else {
            	Entry.showToast('Delete action failed. Error ' + response.err);
						}        		
        	});
				}
      })
      .catch(function(err) {
            Entry.showToast('Delete action canceled');
      });   
		};

		// update elastic fields
    setTimeout (function () {
      $scope.$broadcast('elastic:adjust');
    }, 500);

  }
}

angular.module('amxApp')
  .component('measureInfo', {
    templateUrl: 'app/coverage/routes/measureInfo/measureInfo.html',
    controller: MeasureInfoComponent,
    controllerAs: 'measureInfoCtrl'
  });

})();
