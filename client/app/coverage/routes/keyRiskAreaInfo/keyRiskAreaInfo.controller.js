'use strict';

(function(){

class KeyRiskAreaInfoComponent {
  constructor($scope, Entry, Coverage, $state, $stateParams, ConfirmModal, $sce, $uibModal, $timeout, $filter) {
    $scope.entry = Entry;
  	$scope.keyRiskArea = {};
  	$scope.countSelectedRisks = 0;
  	$scope.keyRiskAreaRisks = [];
  	$scope.keyRiskAreaProductGroups = [];
  	$scope.subRisks = [];
    $scope.isDisabled = Entry.isDisabled();
		$scope.loadFinished = false;

	  if ($stateParams.keyRiskAreaId === undefined || $stateParams.keyRiskAreaId === 'newKeyriskArea') {
	  	
	  }
	  else {
	  	Coverage.getKeyRiskArea($stateParams.keyRiskAreaId).then(function(data) {
	  		$scope.keyRiskArea = data;

		  	// product groups
		  	Coverage.getKeyRiskAreaProductGroups($stateParams.keyRiskAreaId).then(function(data) {
		  		$scope.keyRiskAreaProductGroups = data;
		  	});
		  	
		  	// risks
		  	Coverage.getKeyRiskAreaRisks($stateParams.keyRiskAreaId).then(function(data) {
		  		$scope.keyRiskAreaRisks = data;
		  	});
		  	
		  	// subrisks
		    Coverage.getAllSubRisks()
		    	.then(function(data){
		        $scope.subRisks = data;
		  			$scope.loadFinished = true;
		    });

	  	});

	  }

		$scope.getColor = function(str) {
			var colorHash = new window.ColorHash();
			return colorHash.hex(str + 10);
		};

		$scope.save = function() {
			if (!$scope.datoForm.$valid) {
	       Entry.showToast('Please enter all required fields!');
			}
			else if (!$scope.datoForm.$dirty) {
	      Entry.showToast('No unsaved changes. Nothing to save.');
				$state.go('keyRiskAreaTable', {});
			}
			else {
				Coverage.postKeyRiskArea($scope.keyRiskArea).then(function(response) {
					if (response.success) {	
						Entry.showToast('All changes saved!');
						$state.go('keyRiskAreaTable', {});
					}
					else {
						Entry.showToast('Save failed! Error ' + JSON.stringify(response.error));
					}
				});
			}
		};

		$scope.cancel = function() {
			$state.go('keyRiskAreaTable', {});			
		};

    $scope.riskInfo = function(riskId, subProcessId) {
      if (riskId) {
        $state.go('riskInfo', {riskId: riskId}, {reload: true});
      }
      else {
        $state.go('riskInfo', {subProcessId: subProcessId}, {reload: true});
      }
    };

    $scope.getSubRisks = function(riskId) {
      return _.filter($scope.subRisks, function(e) {return e.RISK_ID == riskId;});
    };

		$scope.clickProductGroupCheckbox = function() {
			$scope.countSelectedProductGroups = _.size(_.filter($scope.keyRiskAreaProductGroups, function(r) {return r.SELECTED === 'Y';}));
			// console.log($scope.countSelectedRisks);
		};

		$scope.clickRiskCheckbox = function() {
			$scope.countSelectedRisks = _.size(_.filter($scope.keyRiskAreaRisks, function(r) {return r.SELECTED === 'Y';}));
			// console.log($scope.countSelectedRisks);
		};

		$scope.linkProductGroup = function(){
			Coverage.pickProductGroup($scope.keyRiskAreaProductGroups)
				.then(function(selectedProductGroups){

					Coverage.linkKeyRiskAreaProductGroup($stateParams.keyRiskAreaId, selectedProductGroups)
						.then(function(response) {
							if (response.success) {	
								Entry.showToast(_.size(selectedProductGroups) + ' product group(s) added. All changes saved!');
								//$state.go('keyRiskAreaInfo', {keyRiskAreaId: $stateParams.keyRiskAreaId});			
								$scope.keyRiskAreaProductGroups = $scope.keyRiskAreaProductGroups.concat(selectedProductGroups);
							}
							else {
								Entry.showToast('Link failed! Error ' + JSON.stringify(response.error));
							}				
					});

				});
		};

		$scope.unlinkProductGroup = function() {
			var productGroupList = _.pluck(_.filter($scope.keyRiskAreaProductGroups, function(r) {return r.SELECTED === 'Y';}), 'PRODUCT_GROUP_ID');

			Coverage.unlinkKeyRiskAreaProductGroup($stateParams.keyRiskAreaId, productGroupList).then(function(response) {
					if (response.success) {	
						Entry.showToast($scope.countSelectedProductGroups + ' product group(s) removed. All changes saved!');
						$scope.keyRiskAreaProductGroups = _.reject($scope.keyRiskAreaProductGroups, function(r) {return r.SELECTED === 'Y';});
						$scope.countSelectedProductGroups = 0;
					}
					else {
						Entry.showToast('Unlink failed! Error ' + JSON.stringify(response.error));
					}				
			});
		};

		$scope.unlinkRisk = function() {
			var riskList = _.pluck(_.filter($scope.keyRiskAreaRisks, function(r) {return r.SELECTED === 'Y';}), 'RISK_ID');

			Coverage.unlinkKeyRiskAreaRisks($stateParams.keyRiskAreaId, riskList).then(function(response) {
					if (response.success) {	
						Entry.showToast($scope.countSelectedRisks + ' risk(s) removed. All changes saved!');
						$scope.keyRiskAreaRisks = _.reject($scope.keyRiskAreaRisks, function(r) {return r.SELECTED === 'Y';});
						$scope.countSelectedRisks = 0;
					}
					else {
						Entry.showToast('Unlink failed! Error ' + JSON.stringify(response.error));
					}				
			});
		};

		$scope.linkRisk = function(riskNodes) {
			var addRiskNodesCtrl = function($scope, $uibModalInstance, riskNodes) {        
				$scope.entry = Entry;
				$scope.businessProcesses = [];
				$scope.risks = [];
				$scope.selectedRisks = [];
				$scope._und = _;
				$scope.loadFinished = false;

				Coverage.getRisks()
					.then(function(data){
						$scope.risks = data;


					// filter risks for whcih there are alrady risk nodes
					_.each(riskNodes, function(rn) {
						$scope.risks = _.reject($scope.risks, function(risk) {
							return risk.RISK_ID == rn.RISK_ID;
						});
					});

					$scope.businessProcesses = _.map(_.groupBy(data, 'BUSINESS_PROCESS_ID'), function(g) {
						return { 
								BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
								BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
							};
					});
				});

				$scope.removeAllFilters = function () {
					$scope.entry.searchRiskNode = {};
				};

				$scope.removeFilter = function (element) {
					delete $scope.entry.searchRiskNode[element];
					if (_.size($scope.entry.searchRiskNode) === 0) {
						$scope.entry.searchRiskNode = {};
					}
				};

				$scope.setFilterBusinessProcess = function (businessProcesses) {
					if (businessProcesses) {
						$scope.entry.searchRiskNode.BUSINESS_PROCESS = businessProcesses;
					}
					else {
						delete $scope.entry.searchRiskNode.BUSINESS_PROCESS;
					}
				};

				$scope.updateSelected = function() {
					$scope.selectedRisks = _.filter($scope.risks, function(elem) { return elem.SELECTED == 'Y';});
				};

				// Watch filter change
				var timer = false;
				var timeoutFilterChangeModal = function(newValue, oldValue){
						if(timer){
							$timeout.cancel(timer);
						}
						timer = $timeout(function(){ 

							$scope.loadFinished = false;
							// remove filters with blank values
							$scope.entry.searchRiskNode = _.pick($scope.entry.searchRiskNode, function(value, key, object) {
								return value !== '' && value !== null;
							});
							
							if (_.size($scope.entry.searchRiskNode) === 0) {
								//delete $scope.entry.searchRiskNode;
								$scope.entry.searchRiskNode = {};
							}
										
							$scope.filteredRisks = $filter('filter') ($scope.risks, $scope.entry.searchRiskNode);
							$scope.loadFinished = true;
						}, 400);
				};
				$scope.$watch('entry.searchRiskNode', timeoutFilterChangeModal, true);  

				$scope.cancel = function() {
					$uibModalInstance.dismiss('cancel');
				};

				$scope.save = function() {         
					$uibModalInstance.close($scope.selectedRisks);
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/riskNodeTable/add-risk-nodes-modal.html',
				controller: addRiskNodesCtrl,
				size: 'lg',
				resolve: {
									'riskNodes' : function() { return riskNodes; },
								}
			});

			instance.result.then(function(data){

				_.each(data, function(r) {r.SELECTED = 'N';});
				var riskList = _.pluck(data, 'RISK_ID');

				Coverage.linkKeyRiskAreaRisks($stateParams.keyRiskAreaId, riskList).then(function(response) {
						if (response.success) {	
							Entry.showToast(_.size(data) + ' risk(s) added. All changes saved!');
							//$state.go('keyRiskAreaInfo', {keyRiskAreaId: $stateParams.keyRiskAreaId});			
							$scope.keyRiskAreaRisks = $scope.keyRiskAreaRisks.concat(data);
						}
						else {
							Entry.showToast('Link failed! Error ' + JSON.stringify(response.error));
						}				
				});
			});
		};

		$scope.deleteKeyRiskArea = function(keyRiskAreaId) {
      ConfirmModal('Are you sure you want to delete this key risk area ?')
      .then(function(confirmResult) {
        if (confirmResult) {
        	Coverage.deleteKeyRiskArea(keyRiskAreaId).then(function(response){
						if (response.success) {	
		          Entry.showToast('Key risk area deleted. All changes saved!');
							$state.go('keyRiskAreaTable', {});
						}
						else {
            	Entry.showToast('Delete action failed. Error ' + response.err);
						}        		
        	});
				}
      })
      .catch(function(err) {
      	console.log(err);
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
  .component('keyRiskAreaInfo', {
    templateUrl: 'app/coverage/routes/keyRiskAreaInfo/keyRiskAreaInfo.html',
    controller: KeyRiskAreaInfoComponent,
    controllerAs: 'keyRiskAreaInfoCtrl'
  });

})();
