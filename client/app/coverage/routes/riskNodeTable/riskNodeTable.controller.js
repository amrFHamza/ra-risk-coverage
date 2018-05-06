'use strict';

(function(){

class RiskNodeTableComponent {
constructor($scope, Entry, Coverage, $filter, $timeout, $state, $stateParams, ConfirmModal, $uibModal, $location, $anchorScroll, $sce) {
		$scope.entry = Entry;
		$scope.productSegment = {};
		$scope.riskNodes = [];
		$scope.selectedRiskNodes = [];
		$scope.businessProcesses = [];
		$scope.loadFinished = false;
		$scope.showSubriskCoverageSlider = false;    
		$scope.showControlEffectivenessSlider = false; 
		$scope.riskNodeControlLinkMode = false; 
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.filteredRiskNodesSystemGroup = {};

		$scope._und = _;

		// remove filters with blank values
		$scope.entry.searchRiskNode = _.pick($scope.entry.searchRiskNode, function(value, key, object) {
			return value !== '' && value !== null;
		});
		
		if (_.size($scope.entry.searchRiskNode) === 0) {
			$scope.entry.searchRiskNode = {};
		}
				
		var loadRiskNodes = function(callback) {
			Coverage.getRiskNodes({PRODUCT_SEGMENT_ID: $stateParams.productSegmentId})
				.then(function(data){
					$scope.riskNodes = data;
					_.each($scope.riskNodes, function(rn){
						rn.SHOW_INFO = false;
					});

					$scope.businessProcesses = _.map(_.groupBy(data, 'BUSINESS_PROCESS_ID'), function(g) {
						return { 
								BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
								BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
							};    
					});
					callback();
			});
		};

		var filterRiskNodes = function(options) {

				$scope.loadFinished = false;

				// Reload if options.RELOAD = true
				if (typeof options !== 'undefined' && options.RELOAD) {
					$scope.riskNodes = [];
					loadRiskNodes(function(){
						options.RELOAD = false;

						// Scroll to active RISK_ID but wait a bit in order page to be rendered
						$timeout(function(){	
							filterRiskNodes(options);
							$location.hash(options.SHOW_INFO_RISK_ID);
	      			$anchorScroll();
						}, 200);

					});
				}

				// filter and group risk nodes
				if (_.size($scope.entry.searchRiskNode) > 0) {
					$scope.filteredRiskNodes = $filter('filter') ($scope.riskNodes, $scope.entry.searchRiskNode);
				}
				else {
					$scope.filteredRiskNodes = $scope.riskNodes;
				}
				
				$scope.filteredRiskNodesSystemGroup = _.groupBy($scope.filteredRiskNodes, 'RISK_ID');

				var riskNodeGroupAttributes = _.map($scope.filteredRiskNodesSystemGroup, function(g) {
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
						RISK_NODE_ID: _.reduce(g, function(m,x) { return x.RISK_NODE_ID; }, 0),
						CONTROL_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROL_COUNT; }, 0),
						SUB_RISK_COUNT: _.reduce(g, function(m,x) { return m + x.SUB_RISK_COUNT; }, 0),
						RPN_COUNT: _.reduce(g, function(m,x) { return m + x.RPN_COUNT; }, 0),
						COVERED_RPN: _.reduce(g, function(m,x) { return m + x.RPN_COUNT * x.COVERAGE; }, 0),
						GROUP_RISK_NODE_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
						COVERED_MEASURE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
						CONTROLS_LIST: _.reduce(g, function(m,x) { return (m?m:'') + (m?'<br><br>':'') + (x.CONTROLS_LIST?x.CONTROLS_LIST:''); }, 0),
					};
				});

				_.each(riskNodeGroupAttributes, function(e) {
					e.MEASURE_COVERAGE = e.COVERED_MEASURE / e.GROUP_RISK_NODE_COUNT;
					e.COVERAGE = e.COVERED_RPN / e.RPN_COUNT;
				});
				
				// create group-level attributes
				_.each($scope.filteredRiskNodesSystemGroup, function(riskNodeGroup, riskId) {
					riskNodeGroup.ATTR = _.find(riskNodeGroupAttributes, function(a) { return a.RISK_ID == riskId; });

					// riskNodeGroup.SHOW_INFO = false;
					riskNodeGroup.active = 0;

					// Create common group info attributes on root level - taken from first element
					_.each(riskNodeGroup[0], function(riskNodeAttributeValue, riskNodeAttributeKey) {
						riskNodeGroup[riskNodeAttributeKey] = angular.copy(riskNodeAttributeValue);
					});
				});

				// expand group and select tab number if defined in the options 
				if (typeof options !== 'undefined' && options.SHOW_INFO_RISK_ID) {
					var showInfoGroup = _.find($scope.filteredRiskNodesSystemGroup, function(g){
						return g.RISK_ID == options.SHOW_INFO_RISK_ID;
					});

					if (showInfoGroup) {
						$timeout(function() {
							showInfoGroup.active = options.ACTIVE;
							$scope.riskNodeInfo(showInfoGroup);
						}, 100);
					}
				}	

				$scope.loadFinished = true;
		};

		loadRiskNodes(function(){
			if ($stateParams.riskId) {
				$scope.entry.searchRiskNode = {};
				filterRiskNodes({SHOW_INFO_RISK_ID: $stateParams.riskId, ACTIVE: (typeof $stateParams.tabId !== 'undefined'?Number($stateParams.tabId):0) , RELOAD: true});
			}
			else {
				filterRiskNodes();
			}
		});

		var refreshProductSegmentData = function() {
			if ($stateParams.productSegmentId) {
					Coverage.getProductSegment($stateParams.productSegmentId)
						.then(function(data){
							$scope.productSegment = data;
							if ($scope.entry.OPCO_ID !== $scope.productSegment.OPCO_ID) {
								$scope.entry.OPCO_ID = $scope.productSegment.OPCO_ID;
								$scope.isDisabled = $scope.entry.isDisabled();
							}     
					});
			}
		};
		refreshProductSegmentData();

		$scope.editProductSegment = function(productSegment) {
			var editProductSegmentCtrl = function($scope, $uibModalInstance, productSegment) {
				
				$scope.entry = Entry;
				$scope.isDisabled = $scope.entry.isDisabled();
				$scope.productGroups = [];
				$scope.productSegment = productSegment;

				Coverage.getProductSegments($scope.productSegment.OPCO_ID).then(function(data){
					//$scope.productSegments = data;
					$scope.productGroups = _.map(_.groupBy(data, 'PRODUCT_GROUP_ID'), function(g) {
						return { 
								LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
								PRODUCT_GROUP: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP; }, 0),
								PRODUCT_GROUP_ID: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP_ID; }, 0),
								LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
								PS_VALUE: _.reduce(g, function(m,x) { return m + x.PS_VALUE; }, 0),
								PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
								RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
								COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_GROUP_VALUE_RATIO/100; }, 0)
							};
					});          
				});

				$scope.cancel = function() {
					$uibModalInstance.dismiss('cancel');
				};

				$scope.save = function() {
					if (!$scope.datoForm.$valid) {
						Entry.showToast('Please enter all required fields!');
					}
					else {          
						$uibModalInstance.close($scope.productSegment);
					}
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/productSegmentTable/edit-product-segment-modal.html',
				controller: editProductSegmentCtrl,
				size: 'lg',
				resolve: {'productSegment' : function() { return productSegment; }}
			});

			instance.result.then(function(data){
				Coverage.editProductSegment(data).then(function(response){
					if (response.success) {
						Entry.showToast('Product segment info changed. All changes saved!');
						$state.go('riskNodeTable', {productSegmentId: response.productSegmentId}, {reload: true});            
					}
					else {
						Entry.showToast('Action failed. Error ' + response.err);
					}     
				});
			});      
		};

		$scope.showSankeyDiagram = function(productSegment) {
			Coverage.showProductSegmentSankeyDiagram(productSegment);
		};

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

			$timeout(function(){ 

				// remove filters with blank values
				$scope.entry.searchRiskNode = _.pick($scope.entry.searchRiskNode, function(value, key, object) {
					return value !== '' && value !== null;
				});
				
				if (_.size($scope.entry.searchRiskNode) === 0) {
					$scope.entry.searchRiskNode = {};
				}
				
				filterRiskNodes();

			}, 400);


		};

		$scope.selectAll = function() {
			_.each($scope.filteredRiskNodesSystemGroup, function(m) {m.ATTR.SELECTED='Y';});
			$scope.updateSelected();
		};

		$scope.unselectAll = function() {
			_.each($scope.filteredRiskNodesSystemGroup, function(m) {m.ATTR.SELECTED='N';});
			$scope.updateSelected();
		};

		$scope.updateSelected = function() {
			$scope.selectedRiskNodes = _.filter($scope.filteredRiskNodesSystemGroup, function(m) { return m.ATTR.SELECTED == 'Y';});
		};

		$scope.linkSystem = function(riskNodes, activeTab) {

			Coverage.linkSystemToRiskNode(riskNodes)
			.then(function(response) {
				var returnRiskNodes = response.RISK_NODES;

				if (response.refreshPage) {
					$state.go('riskNodeTable', $stateParams, {reload: true});					
				}
				else {
					_.each(returnRiskNodes, function(returnRiskNode) {
						$scope.riskNodes = _.reject($scope.riskNodes, function(rn) {return rn.RISK_NODE_ID == returnRiskNode.RISK_NODE_ID;});	
						$scope.riskNodes.push(returnRiskNode);
					});

					// filterRiskNodes();
					if (typeof activeTab !== 'undefined') {
						filterRiskNodes({SHOW_INFO_RISK_ID: riskNodes[0].RISK_ID, ACTIVE: (Number(activeTab)?activeTab:0), RELOAD: true});					
					}
					else {
						filterRiskNodes();
					}
					refreshProductSegmentData();
				}
			});

		};

		$scope.addSystem = function(riskNodes) {
      var newNode = angular.copy(riskNodes[0]);
      newNode.RISK_NODE_ID_OLD = newNode.RISK_NODE_ID; 
      delete newNode.RISK_NODE_ID;
      newNode.SYSTEM_ID = null;
      newNode.COVERAGE = 0;
      newNode.MEASURE_COVERAGE = 0;
      newNode.CONTROLS = [];

			Coverage.linkSystemToRiskNode([newNode]).then(function(data) {
				$scope.riskNodes.push(data.RISK_NODES[0]);
				filterRiskNodes({SHOW_INFO_RISK_ID: data.RISK_NODES[0].RISK_ID, ACTIVE: riskNodes.length, RELOAD: true});
				refreshProductSegmentData();
			});
		};

		$scope.addRiskNodes = function(productSegment, riskNodes) {
			var addRiskNodesCtrl = function($scope, $uibModalInstance, productSegment, riskNodes) {        
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

					// add specific productSegment attributes to risks
					_.each($scope.risks, function(risk) {
						risk.OPCO_ID = productSegment.OPCO_ID;
						risk.PRODUCT_SEGMENT_ID = productSegment.PRODUCT_SEGMENT_ID;
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
									'productSegment' : function() { return productSegment; },
									'riskNodes' : function() { return riskNodes; },
								}
			});

			instance.result.then(function(data){
				Coverage.postRiskNodes(data).then(function(response) {
          if (response.success) {
            Entry.showToast(data.length + ' risk nodes created. All changes saved!');
						$state.go('riskNodeTable', {productSegmentId: $scope.productSegment.PRODUCT_SEGMENT_ID}, {reload: true});            
          }
          else {
            Entry.showToast('Error ' + response.error.code);
          }   
				});
			});
		};

		$scope.deleteSystemRiskNodes = function(riskNodes, activeTab, totalTabs) {
			ConfirmModal('Are you sure you want to delete selected risk nodes? All linked subrisks, controls and measers will be unlinked.')
			.then(function(confirmResult) {
				if (confirmResult) {

					Coverage.deleteRiskNodes(riskNodes).then(function(response){
						if (response.success) {	
							_.each(riskNodes, function(deletedRiskNode) {
								$scope.riskNodes = _.reject($scope.riskNodes, function(rn) {return rn.RISK_NODE_ID == deletedRiskNode.RISK_NODE_ID;});	
							});

							$scope.unselectAll();

							filterRiskNodes({SHOW_INFO_RISK_ID: riskNodes[0].RISK_ID, ACTIVE:(activeTab<totalTabs?Number(activeTab):totalTabs-1)});
							refreshProductSegmentData();

							Entry.showToast('Risk nodes deleted. All changes saved!');
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

		$scope.deleteSelectedRiskNodes = function(selectedRiskNodes) {
			ConfirmModal('Are you sure you want to delete selected risk nodes? All linked subrisks, controls and measers will be unlinked.')
			.then(function(confirmResult) {
				if (confirmResult) {

					var riskNodes = [];
					_.each(selectedRiskNodes, function(rnGroup) {
						_.each(rnGroup, function(rn) {
							riskNodes.push(rn);
							$scope.riskNodes = _.reject($scope.riskNodes, function(drn) {return drn.RISK_NODE_ID == rn.RISK_NODE_ID;});
						});
					});

					Coverage.deleteRiskNodes(riskNodes).then(function(response){
						if (response.success) {	

							filterRiskNodes();
							refreshProductSegmentData();
							$scope.unselectAll();

							Entry.showToast('Risk nodes deleted. All changes saved!');
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

		$scope.riskNodeInfo = function(riskNodeGroup) {

			// find expanded riskNodeGroup if any
			var selectedRiskNodeGroup = _.find($scope.filteredRiskNodesSystemGroup, function(rnGroup) {
				return rnGroup.SHOW_INFO;
			});

			// Save expanded riskNode if still in LinkMode
			if ($scope.riskNodeControlLinkMode) {
				$scope.updateRiskNode(selectedRiskNodeGroup[selectedRiskNodeGroup.active]);
				$scope.riskNodeControlLinkMode = false;	
			}

			// No previous riskNodeGroup found
			if (typeof selectedRiskNodeGroup === 'undefined') {
				_.each(riskNodeGroup, function(rn) {
					Coverage.getRiskNodeDetails(rn);
				});				
				riskNodeGroup.SHOW_INFO = true;
			}
			// Switch from one to other risk node group
			else if (typeof selectedRiskNodeGroup !== 'undefined' && selectedRiskNodeGroup.RISK_ID !== riskNodeGroup.RISK_ID) {
				selectedRiskNodeGroup.SHOW_INFO = false;
				filterRiskNodes({SHOW_INFO_RISK_ID: riskNodeGroup.RISK_ID, ACTIVE:0});
				refreshProductSegmentData();
			}
			// colapse selected node
			else {
				filterRiskNodes();
				refreshProductSegmentData();
				riskNodeGroup.SHOW_INFO = false;
			}
			
			// toggle table display flag
			// riskNodeGroup.SHOW_INFO = !riskNodeGroup.SHOW_INFO;

			// _.each($scope.filteredRiskNodesSystemGroup, function(m) {
			// 	if (m.ATTR.RISK_ID != riskNodeGroup.ATTR.RISK_ID) m.SHOW_INFO = false;
			// });
		};

		$scope.linkSubRisk = function(riskNode) {
			
			var linkSubRiskCtrl = function($scope, $uibModalInstance, riskNode) {
				$scope.subRisks = _.filter(riskNode.SUB_RISKS, function(e){ return e.RN_SUB_RISK_ID == 'NA'; });

				$scope.cancel = function() {
					$uibModalInstance.dismiss('cancel');
				};

				$scope.submit = function(subRisk) {
					$uibModalInstance.close(subRisk);
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/riskNodeTable/link-sub-risk-to-risk-node-modal.html',
				controller: linkSubRiskCtrl,
				size: 'md',
				resolve: {'riskNode' : function() { return riskNode; }}
			});

			instance.result
			.then(function(data){
				data.RN_SUB_RISK_ID = null;
				$scope.updateRiskNode(riskNode);
				Entry.showToast('Risk node modified. All changes saved!');
			});

		};

		$scope.unlinkSubRisk = function(rnSubriskId, riskNode) {
			Coverage.unlinkSubRisk(rnSubriskId).then(function(response){
				if (response.success) { 
					Coverage.getRiskNodeDetails(riskNode);
					refreshProductSegmentData();
					Entry.showToast('Risk node modified. All changes saved!');
				}
				else {
					Entry.showToast('Delete action failed. Error ' + response.err);
				}           
			});
		};

		$scope.addRiskNodeComment = function(riskNode){
			riskNode.commentMode = true;
		};

		$scope.saveRiskNodeComment = function(riskNode) {
			Coverage.saveRiskNodeComment(riskNode).then(function(response){
				if (response.success) { 
					Entry.showToast('Risk node comment saved!');
				}
				else {
					Entry.showToast('Save action failed. Error ' + response.err);
				}           
			});
		};

		$scope.deleteRiskNodeComment = function(riskNode) {
			riskNode.COMMENT = null;
			Coverage.saveRiskNodeComment(riskNode).then(function(response){
				if (response.success) { 
					Entry.showToast('Risk node comment removed!');
					riskNode.commentMode = false;
				}
				else {
					Entry.showToast('Save action failed. Error ' + response.err);
				}           
			});			
		};

		$scope.cloneOtherProductSegment = function(opcoId, cloneToProductSegmentId) {
			
			var cloneOtherProductSegmentCtrl = function($scope, $uibModalInstance, $http, $filter, $timeout) {
				$scope.productSegments = [];
				$scope.cloneFromProductSegmentId = null;
				$scope.loadFinished = false;
    		$scope._und = _;

				Coverage.getCloneOtherProductSegment(opcoId, cloneToProductSegmentId).then(function(data){ 
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
				controller: cloneOtherProductSegmentCtrl,
				size: 'lg'
			});

			instance.result.then(function(cloneFromProductSegment){
				// Set control effectiveness
	      ConfirmModal('All risk nodes in current product segment will be replaced with the ones from selected product segment "' + cloneFromProductSegment.LOB + ' / ' + cloneFromProductSegment.PRODUCT_SEGMENT + '". Are you sure you want to continue? ')
	      .then(function(confirmResult) {
	        if (confirmResult) {
						Coverage.getExecuteCloneOtherProductSegment(cloneFromProductSegment.PRODUCT_SEGMENT_ID, cloneToProductSegmentId)
						.then(function(data){
							Entry.showToast('Product segment "' + cloneFromProductSegment.LOB + ' / ' + cloneFromProductSegment.PRODUCT_SEGMENT + '" was cloned successfully!. All changes saved!');
							$state.go('riskNodeTable', {productSegmentId: cloneToProductSegmentId}, {reload: true});
						});
					}
					else {
							Entry.showToast('Product segment cloning was cancelled. No changes made!');
					}
				}).catch(function(err) {
							Entry.showToast('Product segment cloning was cancelled. No changes made!');
     		});
			});			
		};


		$scope.compareProductSegments = function(opcoId, cloneToProductSegmentId) {
			
			var compareProductSegmentsCtrl = function($scope, $uibModalInstance, $http, $filter, $timeout) {
				$scope.productSegments = [];
				$scope.cloneFromProductSegmentId = null;
				$scope.loadFinished = false;
    		$scope._und = _;

				Coverage.getCloneOtherProductSegment(opcoId, cloneToProductSegmentId).then(function(data){ 
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
				controller: compareProductSegmentsCtrl,
				size: 'lg'
			});

			instance.result.then(function(cloneFromProductSegment){
				// Set control effectiveness
				$state.go('productSegmentCompare', {productSegmentIdA: cloneToProductSegmentId, productSegmentIdB: cloneFromProductSegment.PRODUCT_SEGMENT_ID}, {reload: true});
			});			
		};


		$scope.cloneControlsFromOtherRiskNode = function(riskNode, active) {
			
			var cloneControlsFromOtherRiskNodeCtrl = function($scope, $uibModalInstance, $http, $filter, $timeout) {
				$scope.riskNodes = [];
				$scope.toRiskNode = riskNode;
				$scope.loadFinished = false;

				Coverage.getCloneControlsRiskNodes(riskNode.RISK_NODE_ID).then(function(data){          

					$scope.riskNodes = data;
					$scope.loadFinished = true;

					// Pagination in controller
					$scope.pageSize = 10;
					$scope.currentPage = 1;

				});

				$scope.getColor = function(str) {
					var colorHash = new window.ColorHash();
					return colorHash.hex(str);
				};
		
				$scope.setCurrentPage = function(currentPage) {
						$scope.currentPage = currentPage;
				};

				$scope.modalCancel = function () {
					$uibModalInstance.dismiss('User cancel');
				};

				$scope.selectRiskNode = function (cloneRiskNode) {
					$uibModalInstance.close(cloneRiskNode);
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/riskNodeTable/clone-controls-from-other-risk-node-modal.html',
				controller: cloneControlsFromOtherRiskNodeCtrl,
				size: 'md'
			});

			instance.result.then(function(data){
				// Set control effectiveness

				Coverage.getExecuteCloneControlsRiskNodes(data.RISK_NODE_ID, riskNode.RISK_NODE_ID)
				.then(function(data){          
					// console.log(data);
				});

				$timeout(function() {
					// select new control
					filterRiskNodes({SHOW_INFO_RISK_ID: riskNode.RISK_ID, ACTIVE: active, RELOAD: true});
					refreshProductSegmentData();
					Entry.showToast('Risk node modified. All changes saved!');
				}, 800);
			});			
		};

		$scope.linkControl = function(riskNode) {
			
			var linkControlCtrl = function($scope, $uibModalInstance, $http, hideControls, $filter, $timeout) {
				$scope.controls = [];
				$scope.loadFinished = false;

				Coverage.getControls(riskNode.OPCO_ID, riskNode.SYSTEM_ID).then(function(data){          

					// Remove all items from returned list that are passed in hideControls array
					if (typeof hideControls !== 'undefined' && hideControls.length) {
						// for (var i = 0; i < hideControls.length; i++) {
						// 	data = _.reject(data, function(item) {return item.CONTROL_ID == hideControls[i].CONTROL_ID;});
						// }

						_.each(hideControls, function(hideControl){
							data = _.reject(data, function(item) {return item.CONTROL_ID == hideControl.CONTROL_ID;});
						});
					}

					$scope.controls = data;
					$scope.filteredControls = $filter('filter') ($scope.controls, $scope.entry.searchControl);
					$scope.loadFinished = true;

					// Pagination in controller
					$scope.pageSize = 10;
					$scope.currentPage = 1;

				});

				$scope.setCurrentPage = function(currentPage) {
						$scope.currentPage = currentPage;
				};

				// Watch filter change
				var timeoutControlFilterChange = function(newValue, oldValue){
						 // remove filters with blank values
						$scope.entry.searchControl = _.pick($scope.entry.searchControl, function(value, key, object) {
							return value !== '' && value !== null;
						});

						if (_.size($scope.entry.searchControl) === 0) {
							delete $scope.entry.searchControl;
						}  
							
						$timeout(function(){
							$scope.filteredControls = $filter('filter') ($scope.controls, $scope.entry.searchControl);
							$scope.currentPage = 1;
						}, 400);
				};
				$scope.$watch('entry.searchControl', timeoutControlFilterChange, true);   

				$scope.removeAllFilters = function () {
					delete $scope.entry.searchControl;
				};

				$scope.removeFilter = function (element) {
					delete $scope.entry.searchControl[element];
					if (_.size($scope.entry.searchControl) === 0) {
						delete $scope.entry.searchControl;
					}
				};

				$scope.modalCancel = function () {
					$uibModalInstance.dismiss('User cancel');
				};

				$scope.selectControl = function (control) {
					$uibModalInstance.close(control);
				};

			};

			var instance = $uibModal.open({
				templateUrl: 'app/coverage/routes/riskNodeTable/link-control-to-risk-node-modal.html',
				controller: linkControlCtrl,
				size: 'md',
				resolve: {'hideControls' : function() { return riskNode.CONTROLS; }}
			});

			instance.result.then(function(data){
				// Set control effectiveness
				if (data.CONTROL_TYPE == 'M') {
					data.EFFECTIVENESS = 40;
				}
				else {
					data.EFFECTIVENESS = 100;
				}

				riskNode.CONTROLS.push(data);

				$scope.updateRiskNode(riskNode);
				Entry.showToast('Risk node modified. All changes saved! Please link the control with the relevant sub-risks');

				$timeout(function() {
					// select new control
					var control = _.find(riskNode.CONTROLS, function(c) { return c.CONTROL_ID == data.CONTROL_ID; } );
					control.SELECTED = 'Y';
					$scope.riskNodeControlCheck(control, riskNode);
				}, 800);
			});
		};

		$scope.unlinkControl = function(rnControlId, riskNode, activeTab) {
			Coverage.unlinkControl(rnControlId).then(function(response){
				if (response.success) {
					riskNode.CONTROLS = _.reject(riskNode.CONTROLS, function(c) {return c.RN_CONTROL_ID == rnControlId;});
					delete riskNode.CTRL_SUB_RISKS[rnControlId];
					delete riskNode.CTRL_MEASURES[rnControlId];
					$scope.updateRiskNode(riskNode);
					Entry.showToast('Risk node modified. All changes saved!');
					// filterRiskNodes({SHOW_INFO_RISK_ID: riskNode.RISK_ID, ACTIVE: (activeTab?activeTab:0), RELOAD: true});
					// refreshProductSegmentData();

					// Coverage.getRiskNodeDetails(riskNode);
					// refreshProductSegmentData();
					// Entry.showToast('Risk node ' + riskNode.RISK_NODE_ID + ' was modified. All changes saved!');
				}
				else {
					Entry.showToast('Delete action failed. Error ' + response.err);
				}           
			});
		};

		$scope.updateRiskNode = function(riskNode) {
			// set coverage based on linked controls
			$scope.updateRiskNodeSubRiskCoverage(riskNode);

			Coverage.postRiskNode(riskNode).then(function(data){
				Coverage.getRiskNodeDetails(riskNode);
				$scope.showSubriskCoverageSlider = false;
				$scope.showControlEffectivenessSlider = false;
				$scope.riskNodeControlLinkMode = false;
//				endControlLinkMode(riskNode);
				refreshProductSegmentData();       
			});

		};

		$scope.getLinkedControlsR = function(subRisk, riskNode) {
			var subRiskArr = [];
			// parse links for all controls (groups)
			_.each(riskNode.CTRL_SUB_RISKS, function(subRiskElements, rnCtrlId) {
				subRiskArr = subRiskArr.concat(_.filter(subRiskElements, function(sr){
					return sr.RN_SUB_RISK_ID == subRisk.RN_SUB_RISK_ID;
				 }));
			});
			return _.pluck(subRiskArr, 'RN_CONTROL_ID');
		};

		$scope.getLinkedControlsM = function(measure, riskNode) {
			var subRiskArr = [];
			// parse links for all controls (groups)
			_.each(riskNode.CTRL_MEASURES, function(measureElements, rnCtrlId) {
				subRiskArr = subRiskArr.concat(_.filter(measureElements, function(m){
					return m.MEASURE_ID == measure.MEASURE_ID;
				 }));
			});
			return _.pluck(subRiskArr, 'RN_CONTROL_ID');
		};

		$scope.getColor = function(str) {
			var colorHash = new window.ColorHash();
			return colorHash.hex(str);
		};

		$scope.manualUpdateSubRiskCoverage = function(subRisk, riskNode) {
			subRisk.FIXED = 'Y';

			$scope.updateRiskNode(riskNode);
		};

		$scope.unlockSubRiskCoverage = function(subRisk, riskNode) {
			subRisk.COVERAGE = 0;

			$scope.updateRiskNode(riskNode);
		};

		// Calculate risk-node coverage
		$scope.updateRiskNodeSubRiskCoverage = function(riskNode) {
			//set all sub-risks to 0 
			_.each(riskNode.SUB_RISKS, function(sr) {
				if (sr.FIXED == 'N') {
					sr.COVERAGE = 0;
				}
				else {
					// Remove fixed sub-risk coverage if no controls are linked
					var subRiskControls = [];
					_.each(riskNode.CTRL_SUB_RISKS, function(subRiskElements, rnCtrlId) {
						var findCtrl = _.find(subRiskElements, function(c) { return c.RN_SUB_RISK_ID == sr.RN_SUB_RISK_ID; });
						if (findCtrl) {
							subRiskControls.push(findCtrl);
						}
					});

					if (!subRiskControls.length && sr.COVERAGE) {
						sr.FIXED = 'N';
						sr.COVERAGE = 0;
						Entry.showToast('Locked coverage value without linked control is not possible. Sub-risk #' + sr.RN_SUB_RISK_ID + ' coverage reset to 0%');
					}
				}
			});

			// parse links for all controls and calculate subRisk coverage
			_.each(riskNode.CTRL_SUB_RISKS, function(subRiskElements, rnCtrlId) {
				if (subRiskElements.length) { 
					var control = getRiskNodeControlById(rnCtrlId, riskNode);

					_.each(subRiskElements, function(sr){
						var subRisk = getRiskNodeSubRiskById(sr.RN_SUB_RISK_ID, riskNode);
						
						if (subRisk.FIXED == 'N' && control.STATUS_CODE == 'A' && control.EFFECTIVENESS > subRisk.COVERAGE) {
							subRisk.COVERAGE = control.EFFECTIVENESS;
						}
					});
				}
			});

			// parse all subRisks and calculate Risk node coverage 
			var riskNodeCoverage = 0;
			_.each(riskNode.SUB_RISKS, function(sr) {
				riskNodeCoverage += (sr.LIKELIHOOD * sr.IMPACT)/riskNode.RPN_COUNT * sr.COVERAGE;
			});
			riskNode.COVERAGE = riskNodeCoverage;

			// calculate Risk node measure coverage 
			var riskNodeRequiredMeasureCount = 0;
			var riskNodeCoveredRequiredMeasureCount = 0;
			_.each(riskNode.MEASURES, function(m) {
				var linkedControls = $scope.getLinkedControlsM(m, riskNode);
				if (m.REQUIRED == 'Y') {
					riskNodeRequiredMeasureCount = riskNodeRequiredMeasureCount + 1;
					if ($scope.getLinkedControlsM(m, riskNode).length) {
						riskNodeCoveredRequiredMeasureCount = riskNodeCoveredRequiredMeasureCount + 1;
					}
				}
			});
			if (riskNodeRequiredMeasureCount) {
				riskNode.MEASURE_COVERAGE = riskNodeCoveredRequiredMeasureCount / riskNodeRequiredMeasureCount * 100;
			}
			else {
				riskNode.MEASURE_COVERAGE	= 100;
			}
			
		};

		// Helper function
		var getRiskNodeSelectedControl = function(riskNode) {
			return _.find(riskNode.CONTROLS, function(c) {return c.SELECTED == 'Y';});
		};

		var getRiskNodeControlById = function(rnControlId, riskNode) {
			return _.find(riskNode.CONTROLS, function(c) {return c.RN_CONTROL_ID == rnControlId;});
		};

		var getRiskNodeSubRiskById = function(rnSubRiskId, riskNode) {
			return _.find(riskNode.SUB_RISKS, function(c) {return c.RN_SUB_RISK_ID == rnSubRiskId;});
		};

		var getRiskNodeMeasureById = function(measureId, riskNode) {
			return _.find(riskNode.MEASURES, function(m) {return m.MEASURE_ID == measureId;});
		};

		var checkLinkedSubRisks = function(rnControlId, riskNode) {
			// uncheck all sub-risks
			_.each(riskNode.SUB_RISKS, function(sr) { sr.SELECTED = 'N'; });

			// select ones linked with the provided control id
			_.each(_.find(riskNode.CTRL_SUB_RISKS, function(subRiskElements, rnCtrlId) { return rnCtrlId == rnControlId; }), 
					function(sr) {
						getRiskNodeSubRiskById(sr.RN_SUB_RISK_ID, riskNode).SELECTED = 'Y';
			});
		};

		var checkLinkedMeasures = function(rnControlId, riskNode) {
			// uncheck all sub-risks
			_.each(riskNode.MEASURES, function(sr) { sr.SELECTED = 'N'; });

			// select ones linked with the provided control id
			_.each(_.find(riskNode.CTRL_MEASURES, function(measureElements, rnCtrlId) { return rnCtrlId == rnControlId; }), 
					function(m) {
						getRiskNodeMeasureById(m.MEASURE_ID, riskNode).SELECTED = 'Y';
			});
		};

		$scope.getSubRiskMeasures = function(subRiskId, systemRiskNodeMeasures) {
			var subRiskMeasures =  _.reject(systemRiskNodeMeasures, function(e) { return e.SUB_RISK_ID != subRiskId; });
			return subRiskMeasures;
		};

	  $scope.getSubRiskMeasurePopover = function (measure) {
		  	var popoverTxt = ` 
						    <table class="sm-margins" style="width:500px">		
							    <tbody>	
										<tr>
											<td width="7px" class="` + ((measure.RELEVANT == 'N')?'label-grey':((measure.REQUIRED == 'N')?('label-yellow'):('label-red'))) + `"></td>
											<td style="width:70px; vertical-align: middle; text-align: center;">
												<strong>` + measure.BUSINESS_PROCESS_ID + '-' + measure.MEASURE_ID + `</strong>
											<td style="width:2px; border-left: 1px solid;">&nbsp;</td>
											<td style="vertical-align: middle; text-align: left;" flex>
												<strong>` + measure.MEASURE_NAME + `</strong> <br/>
												<span class="btn-grey no-margins">` + measure.MEASURE_DESCRIPTION + `
													<span class="btn-blue"> <i class="fa fa-fw fa-caret-right"></i>` + measure.MEASURE_TYPE + `</span>
												</span>
											</td>
										</tr>
									</tbody>
								</table>	
		  		`;

	  	return trusted[popoverTxt] || (trusted[popoverTxt] = $sce.trustAsHtml(popoverTxt));
	  };

		var endControlLinkMode = function (riskNode) {
			$scope.riskNodeControlLinkMode = false;
			riskNode.CONTROLS.forEach(function(e){ e.SELECTED = 'N'; });
			riskNode.SUB_RISKS.forEach(function(e){ e.SELECTED = 'N'; });
			riskNode.MEASURES.forEach(function(e){ e.SELECTED = 'N'; });
			$scope.updateRiskNode(riskNode);
		};

		// Helper funcion
		// Helper funcion

		$scope.riskNodeControlCheck = function(control, riskNode) {
			if (control.SELECTED == 'Y') {
				$scope.riskNodeControlLinkMode = true;
				
				//uncheck all except rnControlId 
				riskNode.CONTROLS.forEach(function(c){
					if (c.SELECTED == 'Y' && c.RN_CONTROL_ID !== control.RN_CONTROL_ID) {
						c.SELECTED = 'N';
					}
				});
				//check all linked subRisks
				checkLinkedSubRisks(control.RN_CONTROL_ID, riskNode);
				//check all linked measures
				checkLinkedMeasures(control.RN_CONTROL_ID, riskNode);
			}
			else {
				// save changes
				$scope.updateRiskNode(riskNode);
			}
		};

		$scope.riskNodeControlUnCheck = function(riskNode) {
			$scope.updateRiskNode(riskNode);      
		};

		$scope.riskNodeSubRiskCheck = function (subRisk, riskNode) {
			var rnControlId = getRiskNodeSelectedControl(riskNode).RN_CONTROL_ID;

			if (subRisk.SELECTED == 'Y') {
				if (typeof riskNode.CTRL_SUB_RISKS[rnControlId] === 'undefined') {
					riskNode.CTRL_SUB_RISKS[rnControlId] = [];
				}

				riskNode.CTRL_SUB_RISKS[rnControlId].push({RN_CONTROL_ID:rnControlId, RN_SUB_RISK_ID: subRisk.RN_SUB_RISK_ID});
			}
			else {
				riskNode.CTRL_SUB_RISKS[rnControlId] = _.reject(riskNode.CTRL_SUB_RISKS[rnControlId], function(link) {
					return (link.RN_CONTROL_ID == rnControlId) && (link.RN_SUB_RISK_ID == subRisk.RN_SUB_RISK_ID);
				});
			}

			$scope.updateRiskNodeSubRiskCoverage(riskNode);
			Entry.showToast('Control links modified. All changes saved!');
		};

		$scope.riskNodeMeasureCheck = function (measure, riskNode) {
			var rnControlId = getRiskNodeSelectedControl(riskNode).RN_CONTROL_ID;

			if (measure.SELECTED == 'Y') {
				if (typeof riskNode.CTRL_MEASURES[rnControlId] === 'undefined') {
					riskNode.CTRL_MEASURES[rnControlId] = [];
				}

				riskNode.CTRL_MEASURES[rnControlId].push({RN_CONTROL_ID: rnControlId, MEASURE_ID: measure.MEASURE_ID});
			}
			else {
				riskNode.CTRL_MEASURES[rnControlId] = _.reject(riskNode.CTRL_MEASURES[rnControlId], function(link) {
					return (link.RN_CONTROL_ID == rnControlId) && (link.MEASURE_ID == measure.MEASURE_ID);
				});
			}

			$scope.updateRiskNodeSubRiskCoverage(riskNode);
			Entry.showToast('Control links modified. All changes saved!');
		};

	  var trusted = {};
	  $scope.popoverHtml = function (popoverType) {
	  	var popoverTxt = '';

	  	if (popoverType == 'effectiveness') {
		  	popoverTxt = ` 

		  		<div style="width:500px" layout="row" layout-align="center center" flex class="sm-margins">
		  			<img src="/images/control_effectiveness.png" width="80%"></img>
	    		</div>


	    		<table class="table table-condensed" style="width:500px">	    		
			      <thead>
			          <tr>
			              <th width="50%" colspan="2"><strong>Frequency</strong></th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>5</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Optimising (Very High)</strong><br> 
									<strong>Characterised by:</strong> Frequency is set according to business need and is not limited by data or resource availability. All controls are performed at least once a month and within 24 hours of the data becoming available. <br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>4</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Managed (High)</strong><br> 
									<strong>Characterised by:</strong> Controls are performed regularly, with a frequency of once a month or more, to a predefined schedule. The actual frequency chosen is determined by business need and resource availability.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>3</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Defined (Medium)</strong><br> 
									<strong>Characterised by:</strong> Controls are performed periodically, with a frequency of once a month or more, although the schedule itself is not formalised. Data and resource availability are the key factors when the control(s) are performed.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>2</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Repeatable (Low)</strong><br> 
									<strong>Characterised by:</strong> In response to a requirement of internal or external auditors, or when problems are suspected. Normally once a year or less. <br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>1</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Initial (Very Low)</strong><br> 
									<strong>Characterised by:</strong> Irregular and seldom, only as a result of an individual initiative, not part of a regular program.<br>
			      		</td>
			      	</tr>
			      </tbody>
		  		</table>
		  		
	    		<table class="table table-condensed" style="width:500px">	    		
			      <thead>
			          <tr>
			              <th width="50%" colspan="2"><strong>Extent</strong></th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>5</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Optimising (Very High)</strong><br> 
									<strong>Scope:</strong> 80-100% of data within the scope of the control.<br>
									<strong>Quality:</strong> The used data corresponds to the original data without any summarization and clustering.<br>
									<strong>Characterised by:</strong> Either all of the data is verified by the control or statistically sound sampling is performed that covers the whole data and that sampling is augmented by an “intelligent sample”. The control is a single record level reconciliation which delivers precise results and a full scale of details.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>4</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Managed (High)</strong><br> 
									<strong>Scope:</strong> 60-80% of data within the scope of the control.<br>
									<strong>Quality:</strong> The used data corresponds to the original data without any summarization and clustering.<br>
									<strong>Characterised by:</strong> A large proportion of data is verified by the controls, or if sampling is used it must be representative for the whole data. The control is single record level reconciliation which delivers precise results and a full scale of details.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>3</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Defined (Medium)</strong><br> 
									<strong>Scope:</strong> 40-60% of data within the scope of the reconciliation.<br>
									<strong>Quality:</strong>The aggregation of the data is on a very low level, such as customer accounts, interfaces, products or other relevant characteristics in order to get most specific results.<br>
									<strong>Characterised by:</strong> A large proportion of data is verified by the controls, but may not necessarily be a representative sample of the whole data, or the data reconciliation is a comparison of several KPIs (e.g. such as a sum or count of EDRs, monetary values, duration, etc.) which delivers results with precise focus and information.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>2</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Repeatable (Low)</strong><br> 
									<strong>Scope:</strong> 20-40% of data within the scope of the reconciliation.<br>
									<strong>Quality:</strong>The aggregated / summarized data is at least clustered in brands, markets, technologies or other relevant characteristics in order to get more specific and meaningful results.<br>
									<strong>Characterised by:</strong> Only small proportion of the data is verified by the controls which itself may not be a representative sample of the whole data, or the data reconciliation is a comparison of several KPIs (e.g. such as a sum or count of EDRs, monetary values, duration, etc.) which delivers only a limited level of explanatory value.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="5%"><h4><strong>1</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Initial (Very Low)</strong><br> 
									<strong>Scope:</strong> 0-20% of the data within the scope of the reconciliation. <br>
									<strong>Quality:</strong>The used data is highly aggregated / summarized without any consideration of further characteristics. <br>
									<strong>Characterised by:</strong> Most of the data is not verified by the control, or the reconciliation is a simple comparison of max. 2 KPIs (e.g. such as a sum or count of EDRs, monetary values, duration, input vs output, etc.) which delivers results within a very limited spectrum.<br>
			      		</td>
			      	</tr>
			      </tbody>
		  		</table>
		  		`;		  		
	  	}
	  	else if (popoverType == 'impact') {
		  	popoverTxt = ` 
	    		<table class="table table-condensed" style="width:400px">	
			      <thead>
			          <tr>
			              <th colspan="2"><strong>Likelihood</strong></th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>1</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Unlikely (0-20% probability)</strong><br> 
									<strong>Characterised by:</strong> Automated processes with continuous automated monitoring of controls.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>2</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Seldom (20%-40% probability)</strong><br> 
									<strong>Characterised by:</strong> Automated processes with ad hoc monitoring or regular manual inspection of controls.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>3</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Likely (40%-60% probability)</strong><br> 
									<strong>Characterised by:</strong> Automated processes with no monitoring of controls or high degree of manual processes.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>4</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Very likely (60%-80% probability)</strong><br> 
									<strong>Characterised by:</strong> Partly automated process with some manual processes little or no monitoring of controls.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>5</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Probable (80%-100% probability)</strong><br> 
									<strong>Characterised by:</strong> Manual processes with little or no automation and few automated controls.<br>
			      		</td>
			      	</tr>
			      </tbody>
		  		</table>

	    		<table class="table table-condensed" style="width:400px">	
			      <thead>
			          <tr>
			              <th colspan="2"><strong>Impact</strong></th>
			          </tr>
			      </thead>
			      <tbody>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>1</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Low</strong><br> 
									<strong>Characterised by:</strong> Less than 0.1% of segment value affected.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>2</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Moderate</strong><br> 
									<strong>Characterised by:</strong> Between 0.1% and 0.5% of segment value affected.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>3</strong></h4></td>
			      		<td>
									<strong class="btn-blue">High</strong><br> 
									<strong>Characterised by:</strong> Between 0.5% and 1% of segment value affected.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>4</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Very high</strong><br> 
									<strong>Characterised by:</strong> Between 1% and 5% of segment value affected.<br>
			      		</td>
			      	</tr>
			      	<tr>
			      		<td style="text-align:center;" width="40px"><h4><strong>5</strong></h4></td>
			      		<td>
									<strong class="btn-blue">Severe</strong><br> 
									<strong>Characterised by:</strong> More than 5% of segment value affected.<br>
			      		</td>
			      	</tr>
			      </tbody>
		  		</table>
		  		`;
	  	}

	  	return trusted[popoverTxt] || (trusted[popoverTxt] = $sce.trustAsHtml(popoverTxt));
	  };

		// Watch filter change
		var timeoutFilterChange = function(){
				$timeout(function(){ 

					$scope.loadFinished = false;

					// remove filters with blank values
					$scope.entry.searchRiskNode = _.pick($scope.entry.searchRiskNode, function(value, key, object) {
						return value !== '' && value !== null;
					});
					
					if (_.size($scope.entry.searchRiskNode) === 0) {
						$scope.entry.searchRiskNode = {};
					}
					
					filterRiskNodes();
					$scope.loadFinished = true;

				}, 400);
		};
		$scope.$watch('entry.searchRiskNode', timeoutFilterChange, true);

	}
}

angular.module('amxApp')
	.component('riskNodeTable', {
		templateUrl: 'app/coverage/routes/riskNodeTable/riskNodeTable.html',
		controller: RiskNodeTableComponent,
		controllerAs: 'riskNodeTableCtrl'
	});

})();
