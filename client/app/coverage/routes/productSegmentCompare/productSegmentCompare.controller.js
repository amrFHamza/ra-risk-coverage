'use strict';

(function(){

class ProductSegmentCompareComponent {
  constructor($scope, Entry, Coverage, $filter, $timeout, $state, $stateParams, ConfirmModal, $uibModal, $location, $anchorScroll, $sce, $window) {
		var async = window.async;

		$scope.entry = Entry;
		$scope.riskNodesA = [];
		$scope.riskNodesB = [];
		$scope.riskNodesSystemGroup = [];
		$scope.riskNodesSystemGroupA = [];
		$scope.riskNodesSystemGroupB = [];
		$scope.productSegmentSubRisksA = [];
		$scope.productSegmentSubRisksB = [];
		$scope.productSegmentA = {};
		$scope.productSegmentB = {};
		$scope._und = _;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.loadFinished = false;

		var loadRiskNodes = function(loadFinished) {

			function getGroupAttributes(riskNodesSystemGroup){
				var groupAttributes = _.map(riskNodesSystemGroup, function(g) {
				return {
						OPCO_ID: _.reduce(g, function(m,x) { return x.OPCO_ID; }, 0),
						PRODUCT_SEGMENT_ID: _.reduce(g, function(m,x) { return x.PRODUCT_SEGMENT_ID; }, 0),
						RISK_ID: _.reduce(g, function(m,x) { return x.RISK_ID; }, 0),
						RISK: _.reduce(g, function(m,x) { return x.RISK; }, 0),
						RISK_CATEGORY: _.reduce(g, function(m,x) { return x.RISK_CATEGORY; }, 0),
						RISK_DESCRIPTION: _.reduce(g, function(m,x) { return x.RISK_DESCRIPTION; }, 0),
						BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
						BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
						BUSINESS_SUB_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_SUB_PROCESS; }, 0),
						BUSINESS_SUB_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_SUB_PROCESS_ID; }, 0),
						CONTROL_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROL_COUNT; }, 0),
						SUB_RISK_COUNT: _.reduce(g, function(m,x) { return m + x.SUB_RISK_COUNT; }, 0),
						RPN_COUNT: _.reduce(g, function(m,x) { return m + x.RPN_COUNT; }, 0),
						COVERED_RPN: _.reduce(g, function(m,x) { return m + x.RPN_COUNT * x.COVERAGE; }, 0),
						GROUP_RISK_NODE_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
						COVERED_MEASURE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
					};
				});

				_.each(groupAttributes, function(e) {
					e.MEASURE_COVERAGE = e.COVERED_MEASURE / e.GROUP_RISK_NODE_COUNT;
					e.COVERAGE = e.COVERED_RPN / e.RPN_COUNT;
				});

				return groupAttributes[0];
			}

			async.parallel([
			    function(callback) {
						Coverage.getRiskNodes({PRODUCT_SEGMENT_ID: $stateParams.productSegmentIdA})
							.then(function(data){
								$scope.riskNodesA = data;
								_.each($scope.riskNodesA, function(rn) {rn.CLONE_OVER = true; rn.CLONE = true; rn.CONTROLS_LIST = (rn.CONTROLS_LIST?rn.CONTROLS_LIST.split('<br>'):['']);});
								callback();
						});
			    },
			    function(callback) {
						Coverage.getRiskNodes({PRODUCT_SEGMENT_ID: $stateParams.productSegmentIdB})
							.then(function(data){
								$scope.riskNodesB = data;
								_.each($scope.riskNodesB, function(rn) {rn.CLONE_OVER = true; rn.CLONE = true; rn.CONTROLS_LIST = (rn.CONTROLS_LIST?rn.CONTROLS_LIST.split('<br>'):['']);});
								callback();
						});
			    },
			    function(callback) {
						Coverage.getProductSegment($stateParams.productSegmentIdA)
							.then(function(data){
								$scope.productSegmentA = data;
								callback();
						});
			    },
			    function(callback) {
						Coverage.getProductSegment($stateParams.productSegmentIdB)
							.then(function(data){
								$scope.productSegmentB = data;
								callback();								
						});
			    },
			    function(callback) {
						Coverage.getProductSegmentSubRisks($stateParams.productSegmentIdA)
							.then(function(data){
								$scope.productSegmentSubRisksA = _.groupBy(data, 'RISK_NODE_ID');
								callback();								
						});
			    },
			    function(callback) {
						Coverage.getProductSegmentSubRisks($stateParams.productSegmentIdB)
							.then(function(data){
								$scope.productSegmentSubRisksB = _.groupBy(data, 'RISK_NODE_ID');
								callback();								
						});
			    }
			],
			// Finally callback
			function(err, results) {

				if ($scope.entry.OPCO_ID !== $scope.productSegmentA.OPCO_ID) {
					$scope.entry.OPCO_ID = $scope.productSegmentA.OPCO_ID;
					$scope.isDisabled = $scope.entry.isDisabled();
				}
				else if ($scope.entry.OPCO_ID !== $scope.productSegmentB.OPCO_ID) {
					$scope.entry.OPCO_ID = $scope.productSegmentB.OPCO_ID;
					$scope.isDisabled = $scope.entry.isDisabled();
				}

				// add subrisk infos
				_.each($scope.riskNodesA, function(rn) {rn.SUB_RISKS = _.pluck(_.map(_.sortBy($scope.productSegmentSubRisksA[rn.RISK_NODE_ID], 'SUB_RISK_ID'), function(e) {return {SUB_RISK: e.SUB_RISK_ID + '. ' + e.SUB_RISK}; } ), 'SUB_RISK');});
				_.each($scope.riskNodesA, function(rn) {rn.SUB_RISKS_LI = _.pluck(_.map(_.sortBy($scope.productSegmentSubRisksA[rn.RISK_NODE_ID], 'SUB_RISK_ID'), function(e) {return {SUB_RISK: e.SUB_RISK_ID + '. ' + '(<strong>' + e.LIKELIHOOD + '</strong> &#215; <strong>' + e.IMPACT + '</strong>) ' + e.SUB_RISK }; } ), 'SUB_RISK');});

				_.each($scope.riskNodesB, function(rn) {rn.SUB_RISKS = _.pluck(_.map(_.sortBy($scope.productSegmentSubRisksB[rn.RISK_NODE_ID], 'SUB_RISK_ID'), function(e) {return {SUB_RISK: e.SUB_RISK_ID + '. ' + e.SUB_RISK}; } ), 'SUB_RISK');});
				_.each($scope.riskNodesB, function(rn) {rn.SUB_RISKS_LI = _.pluck(_.map(_.sortBy($scope.productSegmentSubRisksB[rn.RISK_NODE_ID], 'SUB_RISK_ID'), function(e) {return {SUB_RISK: e.SUB_RISK_ID + '. ' + '(<strong>' + e.LIKELIHOOD + '</strong> &#215; <strong>' + e.IMPACT + '</strong>) ' + e.SUB_RISK }; } ), 'SUB_RISK');});

				// create system groups
				$scope.riskNodesSystemGroup = _.groupBy($scope.riskNodesA.concat($scope.riskNodesB), 'RISK_ID');
				$scope.riskNodesSystemGroupA = _.groupBy(_.sortBy($scope.riskNodesA, 'SYSTEM_NAME'), 'RISK_ID');
				$scope.riskNodesSystemGroupB = _.groupBy(_.sortBy($scope.riskNodesB, 'SYSTEM_NAME'), 'RISK_ID');
				
				// create main group-level attributes
				_.each($scope.riskNodesSystemGroup, function(riskNodeGroup) {
					riskNodeGroup.ATTR = getGroupAttributes([riskNodeGroup]);
				});

				// compare risk nodes from A-side
				_.each($scope.riskNodesSystemGroupA, function(riskNodeGroupA) {
					_.each(riskNodeGroupA, function(riskNodeA){
						// riskNodeA.SUB_RISKS_LIST = _.pluck(riskNodeA.SUB_RISKS, 'SUB_RISK').join('<br>');

						var foundExactSameRiskNodeB = _.find($scope.riskNodesSystemGroupB[riskNodeA.RISK_ID],
							function(riskNodeB) {
								return riskNodeB.SYSTEM_ID == riskNodeA.SYSTEM_ID && riskNodeB.CONTROL_COUNT == riskNodeA.CONTROL_COUNT && riskNodeB.SUB_RISK_COUNT == riskNodeA.SUB_RISK_COUNT && riskNodeB.RPN_COUNT == riskNodeA.RPN_COUNT && riskNodeB.SUB_RISKS.join() == riskNodeA.SUB_RISKS.join() && riskNodeB.CONTROLS_LIST.join() == riskNodeA.CONTROLS_LIST.join();
							});

						// forbid cloning if nodes are same
						if (foundExactSameRiskNodeB) {
							riskNodeA.CLONE = false;
						}

						var foundSameSystemRiskNodeB = _.find($scope.riskNodesSystemGroupB[riskNodeA.RISK_ID],
							function(riskNodeB) {
								return riskNodeB.SYSTEM_ID == riskNodeA.SYSTEM_ID;
							});

						if (foundSameSystemRiskNodeB) {
							riskNodeA.CLONE_OVER = false;
						}

						if (foundSameSystemRiskNodeB) {
							var controlsAnB = _.difference(riskNodeA.CONTROLS_LIST, foundSameSystemRiskNodeB.CONTROLS_LIST);
							var controlsBnA = _.difference(foundSameSystemRiskNodeB.CONTROLS_LIST, riskNodeA.CONTROLS_LIST);
							var controlsMatch = _.intersection(riskNodeA.CONTROLS_LIST, foundSameSystemRiskNodeB.CONTROLS_LIST);

							var AnB = _.difference(riskNodeA.SUB_RISKS, foundSameSystemRiskNodeB.SUB_RISKS);
							var BnA = _.difference(foundSameSystemRiskNodeB.SUB_RISKS, riskNodeA.SUB_RISKS);
							var match = _.intersection(riskNodeA.SUB_RISKS, foundSameSystemRiskNodeB.SUB_RISKS);

							var LIAnB = _.difference(riskNodeA.SUB_RISKS_LI, foundSameSystemRiskNodeB.SUB_RISKS_LI);
							var LIBnA = _.difference(foundSameSystemRiskNodeB.SUB_RISKS_LI, riskNodeA.SUB_RISKS_LI);
							var LImatch = _.intersection(riskNodeA.SUB_RISKS_LI, foundSameSystemRiskNodeB.SUB_RISKS_LI);

							riskNodeA.SUB_RISKS_HTML = _.map(AnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(match, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(BnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
							riskNodeA.SUB_RISKS_LI_HTML = _.map(LIAnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(LImatch, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(LIBnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
							riskNodeA.CONTROLS_LIST_HTML = _.map(controlsAnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(controlsMatch, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(controlsBnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
						}
						else {
							riskNodeA.SUB_RISKS_HTML = _.map(riskNodeA.SUB_RISKS, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
							riskNodeA.SUB_RISKS_LI_HTML = _.map(riskNodeA.SUB_RISKS_LI, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
							riskNodeA.CONTROLS_LIST_HTML = _.map(riskNodeA.CONTROLS_LIST, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
						}

					});
				});					

				// compare risk nodes from B-side
				_.each($scope.riskNodesSystemGroupB, function(riskNodeGroupA) {
					_.each(riskNodeGroupA, function(riskNodeA){
						// riskNodeA.SUB_RISKS_LIST = _.pluck(riskNodeA.SUB_RISKS, 'SUB_RISK').join('<br>');

						var foundExactSameRiskNodeB = _.find($scope.riskNodesSystemGroupA[riskNodeA.RISK_ID],
							function(riskNodeB) {
								return riskNodeB.SYSTEM_ID == riskNodeA.SYSTEM_ID && riskNodeB.CONTROL_COUNT == riskNodeA.CONTROL_COUNT && riskNodeB.SUB_RISK_COUNT == riskNodeA.SUB_RISK_COUNT && riskNodeB.RPN_COUNT == riskNodeA.RPN_COUNT && riskNodeB.SUB_RISKS.join() == riskNodeA.SUB_RISKS.join();
							});

						// forbid cloning if nodes are same
						if (foundExactSameRiskNodeB) {
							riskNodeA.CLONE = false;
						}

						var foundSameSystemRiskNodeB = _.find($scope.riskNodesSystemGroupA[riskNodeA.RISK_ID],
							function(riskNodeB) {
								return riskNodeB.SYSTEM_ID == riskNodeA.SYSTEM_ID;
							});

						if (foundSameSystemRiskNodeB) {
							riskNodeA.CLONE_OVER = false;
						}

						if (foundSameSystemRiskNodeB) {
							var controlsAnB = _.difference(riskNodeA.CONTROLS_LIST, foundSameSystemRiskNodeB.CONTROLS_LIST);
							var controlsBnA = _.difference(foundSameSystemRiskNodeB.CONTROLS_LIST, riskNodeA.CONTROLS_LIST);
							var controlsMatch = _.intersection(riskNodeA.CONTROLS_LIST, foundSameSystemRiskNodeB.CONTROLS_LIST);

							var AnB = _.difference(riskNodeA.SUB_RISKS, foundSameSystemRiskNodeB.SUB_RISKS);
							var BnA = _.difference(foundSameSystemRiskNodeB.SUB_RISKS, riskNodeA.SUB_RISKS);
							var match = _.intersection(riskNodeA.SUB_RISKS, foundSameSystemRiskNodeB.SUB_RISKS);

							var LIAnB = _.difference(riskNodeA.SUB_RISKS_LI, foundSameSystemRiskNodeB.SUB_RISKS_LI);
							var LIBnA = _.difference(foundSameSystemRiskNodeB.SUB_RISKS_LI, riskNodeA.SUB_RISKS_LI);
							var LImatch = _.intersection(riskNodeA.SUB_RISKS_LI, foundSameSystemRiskNodeB.SUB_RISKS_LI);

							riskNodeA.SUB_RISKS_HTML = _.map(AnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(match, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(BnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
							riskNodeA.SUB_RISKS_LI_HTML = _.map(LIAnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(LImatch, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(LIBnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
							riskNodeA.CONTROLS_LIST_HTML = _.map(controlsAnB, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).concat(_.map(controlsMatch, function(e){ return '<span class="btn-black">' + e + ' (=)<span>'; })).concat(_.map(controlsBnA, function(e){ return '<span class="btn-red">' + e + ' (-)<span>'; })).join('<br>');
						}
						else {
							riskNodeA.SUB_RISKS_HTML = _.map(riskNodeA.SUB_RISKS, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
							riskNodeA.SUB_RISKS_LI_HTML = _.map(riskNodeA.SUB_RISKS_LI, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
							riskNodeA.CONTROLS_LIST_HTML = _.map(riskNodeA.CONTROLS_LIST, function(e){ return '<span class="btn-green">' + e + ' (+)<span>'; }).join('<br>');
						}

					});
				});	

				loadFinished();
			});
		};

		loadRiskNodes(function(){
			$scope.loadFinished = true;
			console.log($scope.riskNodesSystemGroupA);
		});

		$scope.deleteRiskNode = function(riskNode) {
			Coverage.deleteRiskNodes([riskNode])
			.then(function(response){
				loadRiskNodes(function(){
					if (response.success) {
						Entry.showToast('Risk node deleted. All changes saved!');
					}
					else {
	          Entry.showToast('Delete action failed. Error ' + response.err);					
					}					
				});
			});
		};

		$scope.copyRiskNode = function(riskNode, productSegmentId) {
			var executeClone = function() {
				Coverage.getExecuteCloneRiskNodeToProductSegment(riskNode.RISK_NODE_ID, productSegmentId)
				.then(function(response){
					loadRiskNodes(function(){
						if (response.affectedRows) {
							Entry.showToast('Risk node successfully copied. All changes saved!');
						}
						else {
		          Entry.showToast('Copy action failed. Error ' + response);					
						}					
					});
				});
			};

			var nodeToReplace;
			if (productSegmentId == $stateParams.productSegmentIdA && _.find($scope.riskNodesSystemGroupA[riskNode.RISK_ID], function(rn) {return (rn.SYSTEM_ID?rn.SYSTEM_ID:'0') == (riskNode.SYSTEM_ID?riskNode.SYSTEM_ID:'0');})) {
				nodeToReplace = _.find($scope.riskNodesSystemGroupA[riskNode.RISK_ID], function(rn) {return (rn.SYSTEM_ID?rn.SYSTEM_ID:'0') == (riskNode.SYSTEM_ID?riskNode.SYSTEM_ID:'0');});
				ConfirmModal('Risk node with system "' + (nodeToReplace.SYSTEM_NAME?nodeToReplace.SYSTEM_NAME:'Undefined') + '" already exists. Overwrite?')
				.then(function(confirmResult) {
					if (confirmResult) {				
						executeClone();
					}
				});
			}
			else if (productSegmentId == $stateParams.productSegmentIdB && _.find($scope.riskNodesSystemGroupB[riskNode.RISK_ID], function(rn) {return (rn.SYSTEM_ID?rn.SYSTEM_ID:'0') == (riskNode.SYSTEM_ID?riskNode.SYSTEM_ID:'0');})) {
				nodeToReplace = _.find($scope.riskNodesSystemGroupB[riskNode.RISK_ID], function(rn) {return (rn.SYSTEM_ID?rn.SYSTEM_ID:'0') == (riskNode.SYSTEM_ID?riskNode.SYSTEM_ID:'0');});
				ConfirmModal('Risk node with system "' + (nodeToReplace.SYSTEM_NAME?nodeToReplace.SYSTEM_NAME:'Undefined') + '" already exists. Overwrite?')
				.then(function(confirmResult) {
					if (confirmResult) {				
						executeClone();
					}
				});
			}
			else {
				executeClone();
			}

		};

		$scope.goToProductSegment = function(productSegmentId) {
			$state.go('riskNodeTable', {productSegmentId: productSegmentId}, {reload: true});
		};

		$scope.linkSystem = function(riskNode) {
			Coverage.linkSystemToRiskNode(riskNode)
			.then(function(response) {
					loadRiskNodes(function(){
						if (response.success) {
							Entry.showToast('System changed from "' + (riskNode[0].SYSTEM_NAME?riskNode[0].SYSTEM_NAME:'Undefined') + '"" to "' + response.RISK_NODES[0].SYSTEM_NAME  + '".. All changes saved!');
						}
						else {
		          Entry.showToast('System change action failed!');					
						}					
					});
			});
		};

		$scope.swapProductSegment = function(opcoId, productSegmentId, side) {
			
			var changeCompareProductSegmentCtrl = function($scope, $uibModalInstance, $http, $filter, $timeout) {
				$scope.productSegments = [];
				$scope.cloneFromProductSegmentId = null;
				$scope.loadFinished = false;
    		$scope._und = _;

				Coverage.getCloneOtherProductSegment(opcoId, productSegmentId).then(function(data){ 
          $scope.productSegments = data;
          //$scope.productSegments.forEach(function(e){e.COVERAGE = Math.floor(Math.random() * 100 + 1);})

          $scope.productGroups = _.map(_.groupBy(data, 'PRODUCT_GROUP_ID'), function(g) {
            return { 
                LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
                PRODUCT_GROUP: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP; }, 0),
                PRODUCT_GROUP_ID: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP_ID; }, 0),
                LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
                PS_VALUE: _.reduce(g, function(m,x) { return m + x.PS_VALUE; }, 0),
                PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
                RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
                COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_GROUP_VALUE_RATIO/100; }, 0),
                MEASURE_COVERAGE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
              };
          });

          $scope.filteredProductSegments = $scope.productSegments;
          $scope.groupFilteredProductSegments = _.groupBy($scope.filteredProductSegments, 'PRODUCT_GROUP_ID');          
          $scope.loadFinished = true;

				});

				$scope.getColor = function(str) {
					var colorHash = new window.ColorHash();
					return colorHash.hex(str);
				};

				$scope.modalCancel = function () {
					$uibModalInstance.dismiss('User cancel');
				};

				$scope.selectProductSegment = function (cloneFromProductSegment) {
					$uibModalInstance.close(cloneFromProductSegment);
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/riskNodeTable/clone-other-product-segment-modal.html',
				controller: changeCompareProductSegmentCtrl,
				size: 'lg'
			});

			instance.result.then(function(cloneFromProductSegment){
				// Set control effectiveness
				if (side == 'A') {
					$state.go('productSegmentCompare', {productSegmentIdA: cloneFromProductSegment.PRODUCT_SEGMENT_ID, productSegmentIdB: $stateParams.productSegmentIdB});
				}
				else {
					$state.go('productSegmentCompare', {productSegmentIdA: $stateParams.productSegmentIdA, productSegmentIdB: cloneFromProductSegment.PRODUCT_SEGMENT_ID});
				}
			});			
		};

		$scope.getColor = function(str) {
			var colorHash = new window.ColorHash();
			return colorHash.hex(str);
		};

  }
}

angular.module('amxApp')
  .component('productSegmentCompare', {
    templateUrl: 'app/coverage/routes/productSegmentCompare/productSegmentCompare.html',
    controller: ProductSegmentCompareComponent,
    controllerAs: 'productSegmentCompareCtrl'
  });

})();
