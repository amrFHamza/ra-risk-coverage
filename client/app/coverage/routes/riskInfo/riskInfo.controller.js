'use strict';

(function(){

class RiskInfoComponent {

  constructor($scope, Entry, Coverage, $state, $stateParams, ConfirmModal, $sce) {
    $scope.entry = Entry;
  	$scope.risk = {};
  	$scope.subRisks = [];
  	$scope.processes = [];
  	$scope.measures = [];
  	$scope.subProcesses = [];
    $scope.isDisabled = Entry.isDisabled();

	  if ($stateParams.riskId === undefined || $stateParams.riskId === 'newRisk') {
	  	Coverage.getProcesses().then(function(data) {
	  		$scope.processes = data;
	  	});

		 	Coverage.getSubProcesses().then(function(data) {
		  	$scope.subProcesses = data;
  				if ($stateParams.subProcessId) {
		  			$scope.risk = angular.copy(_.find(data, function(e) {return e.BUSINESS_SUB_PROCESS_ID == $stateParams.subProcessId;}));
  				}
		  });  		
	  }
	  else {
	  	Coverage.getRiskInfo($stateParams.riskId).then(function(data) {
	  		$scope.risk = data;
	  	});

	  	Coverage.getMeasuresForRiskId($stateParams.riskId).then(function(data) {
	  		$scope.measures = data;
	  	});

	  	Coverage.getSubRisks($stateParams.riskId).then(function(data) {
	  		$scope.subRisks = data;
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
			$scope.risk.BUSINESS_PROCESS_ID =  angular.copy(_.find($scope.processes, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_PROCESS_ID;
			$scope.risk.BUSINESS_PROCESS =  angular.copy(_.find($scope.processes, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_PROCESS;
			$scope.risk.BUSINESS_SUB_PROCESS_ID =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_SUB_PROCESS_ID;
			$scope.risk.BUSINESS_SUB_PROCESS =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_PROCESS_ID === processId;})).BUSINESS_SUB_PROCESS;			
  	};

  	$scope.subProcessChanged = function(subProcessId) {
  		// $scope.subRisks = [];
			$scope.risk.BUSINESS_SUB_PROCESS_ID =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_SUB_PROCESS_ID === subProcessId;})).BUSINESS_SUB_PROCESS_ID;
			$scope.risk.BUSINESS_SUB_PROCESS =  angular.copy(_.find($scope.subProcesses, function(e) {return e.BUSINESS_SUB_PROCESS_ID === subProcessId;})).BUSINESS_SUB_PROCESS;
  	};

  	$scope.getMeasures = function(subRiskId){
  		var subProcessMeasures = _.reject($scope.measures, function(e) {return e.SUB_RISK_ID !== subRiskId;});
  		return subProcessMeasures;
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
				Coverage.postRisk({risk: $scope.risk, subRisks: $scope.subRisks}).then(function(response) {
					if (response.success) {	
						Entry.showToast('All changes saved!');
						if (response.RISK_ID) {
							$state.go('riskInfo', {riskId: response.RISK_ID}, {reload: true});
						}
						else {
							$state.go('riskInfo', {riskId: $stateParams.riskId}, {reload: true});
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
			$state.go('riskTable', {});			
		};

		$scope.addSubRisk = function() {
			$scope.subRisks.push({
														BASE_LIKELIHOOD: 1, 
														BASE_IMPACT: 1, 
														RELEVANT: 'Y', 
														REQUIRED: 'N', 
														SOURCE:'TAG'});
		};

		$scope.deleteRisk = function(riskId) {
      ConfirmModal('Are you sure you want to delete risk "' + $scope.risk.RISK + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
        	Coverage.deleteRisk(riskId).then(function(response){
						if (response.success) {	
		          Entry.showToast('Risk deleted. All changes saved!');
							$state.go('riskTable', {});
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

		$scope.deleteRiskMeasureLink = function(riskId, measureId) {
        	Coverage.deleteRiskMeasureLink(riskId, measureId).then(function(response){
						if (response.success) {	
		          Entry.showToast('Measure unlinked from risk. All changes saved!');
		          //$state.go('riskInfo', {riskId: riskId}, {reload: true});
		          $scope.measures = _.reject($scope.measures, function(e) {
		          		return (e.RISK_ID == riskId) && (e.MEASURE_ID == measureId);
		          	});
						}
						else {
            	Entry.showToast('Delete action failed. Error ' + response.err);
						}        		
        	});
		};

		$scope.deleteSubRiskMeasureLink = function(subRiskId, measureId) {
        	Coverage.deleteSubRiskMeasureLink(subRiskId, measureId).then(function(response){
						if (response.success) {	
		          Entry.showToast('Measure unlinked from sub-risk. All changes saved!');
		          //$state.go('riskInfo', {subRiskId: subRiskId}, {reload: true});
		          $scope.measures = _.reject($scope.measures, function(e) {
		          		return (e.SUB_RISK_ID == subRiskId) && (e.MEASURE_ID == measureId);
		          	});
						}
						else {
            	Entry.showToast('Delete action failed. Error ' + response.err);
						}        		
        	});
		};

    $scope.linkMeasureToSubRisk = function(subRiskId) {
      Coverage.linkMeasureToSubRisk({SUB_RISK_ID: subRiskId})
      .then(function(data){
      	$scope.measures = $scope.measures.concat(data);
      	//$state.go('riskInfo', {riskId: $stateParams.riskId});
      });     
    };

    $scope.linkMeasureToRisk = function(riskId) {
      Coverage.linkMeasureToRisk({RISK_ID: riskId})
      .then(function(data){
      	$scope.measures = $scope.measures.concat(data);
      });     
    };

		$scope.deleteSubRisk = function(subRiskId) {
			var subRiskToDelete = _.find($scope.subRisks, function(e) { return e.SUB_RISK_ID == subRiskId; });

      ConfirmModal('Are you sure you want to delete sub-risk "' + subRiskToDelete.SUB_RISK + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
        	Coverage.deleteSubRisk(subRiskId).then(function(response){
						if (response.success) {	
		        	$scope.subRisks = _.filter($scope.subRisks, function(e) { return e.SUB_RISK_ID != subRiskId; });
		          Entry.showToast('Sub-risk deleted. All changes saved!');
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

	  var trusted = {};
	  $scope.popoverHtml = function (popoverType) {
	  	var popoverTxt = '';

	  	if (popoverType == 'likelihood') {
		  	popoverTxt = ` 
	    		<table class="table table-condensed small">	
			      <thead>
			          <tr>
			              <th>Likelihood</th>
			              <th>Description</th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;"><strong>1</strong></td>
			      		<td>Here description how to assess if a risk has a likelihood of degree 1 (low)</td>
			      	</tr>
			      </tbody>
		  		</table>`;
	  	}
	  	else if (popoverType == 'impact') {
		  	popoverTxt = ` 
	    		<table class="table table-condensed small">	
			      <thead>
			          <tr>
			              <th>Impact</th>
			              <th>Description</th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;"><strong>1</strong></td>
			      		<td>Here description how to assess if a risk has a impact of degree 1 (low)</td>
			      	</tr>
			      </tbody>
		  		</table>`;
	  	}

	  	return trusted[popoverTxt] || (trusted[popoverTxt] = $sce.trustAsHtml(popoverTxt));
	  };

		// update elastic fields
    setTimeout (function () {
      $scope.$broadcast('elastic:adjust');
    }, 500);

  }
}

angular.module('amxApp')
  .component('riskInfo', {
    templateUrl: 'app/coverage/routes/riskInfo/riskInfo.html',
    controller: RiskInfoComponent,
    controllerAs: 'riskInfoCtrl'
  });

})();
