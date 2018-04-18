'use strict';

(function(){

class ProcedureInfoComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal, Coverage, dflLinkDatasourceModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
  	$scope.procedure = {};
  	$scope.coverage = [];
  	$scope.subTypes = [];
  	$scope.schedules = [];
  	$scope.procedure.links = [];

	  if ($stateParams.procedureId === undefined) {
	    $state.go('procedureTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }
	  else if ($stateParams.procedureId === 'newJob') {
	  	$scope.procedure.TYPE = 'J';
	  	$scope.procedure.TYPE_TEXT = 'Job';
	  	$scope.procedure.STATUS_CODE = 'A';
	  	$scope.procedure.OPCO_ID = $scope.entry.currentUser.userOpcoId;

			// Get subtypes list
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getProcedureSubTypesList',
				params: {opcoId: $scope.entry.currentUser.userOpcoId, type: $scope.procedure.TYPE}
			}).then(function (response) {
				$scope.subTypes = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});

		  // Get schedules
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getSchedules',
				params: {opcoId: $scope.procedure.OPCO_ID}
			}).then(function (response) {
				$scope.schedules = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});				
	  }
	  else if ($stateParams.procedureId === 'newDato') {
	  	$scope.procedure.TYPE = 'T';
	  	$scope.procedure.SUB_TYPE = 'AMX';
	  	$scope.procedure.TYPE_TEXT = 'Dato';
	  	$scope.procedure.STATUS_CODE = 'A';
	  	$scope.procedure.OPCO_ID = $scope.entry.currentUser.userOpcoId;

	    // Dato.getNotLinkedDatos($scope.entry.currentUser.userOpcoId).then(function (data) {
	    //   $scope.datos = data;
	    // });	

	    // Get schedules
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getSchedules',
				params: {opcoId: $scope.procedure.OPCO_ID}
			}).then(function (response) {
				$scope.schedules = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});

	  }	  
	  else if ($stateParams.procedureId === 'newControl') {
	  	$scope.procedure.TYPE = 'C';
	  	$scope.procedure.TYPE_TEXT = 'Control';
	  	$scope.procedure.STATUS_CODE = 'A';
	  	$scope.procedure.CONTROL_TYPE = 'Reconciliation';
	  	$scope.procedure.OPCO_ID = $scope.entry.currentUser.userOpcoId;
	  	$scope.procedure.START_DATE = null;
	  	$scope.procedure.END_DATE = null;

			// Get subtypes list
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getProcedureSubTypesList',
				params: {opcoId: $scope.entry.currentUser.userOpcoId, type: $scope.procedure.TYPE}
			}).then(function (response) {
				$scope.subTypes = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});

		  // Get schedules
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getSchedules',
				params: {opcoId: $scope.procedure.OPCO_ID}
			}).then(function (response) {
				$scope.schedules = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});

	  }
		else if ($stateParams.procedureId === 'newReport') {
	  	$scope.procedure.TYPE = 'S';
	  	$scope.procedure.TYPE_TEXT = 'Report solution';
	  	$scope.procedure.STATUS_CODE = 'A';
	  	$scope.procedure.SOX_RELEVANT = 'N';
	  	$scope.procedure.OPCO_ID = $scope.entry.currentUser.userOpcoId;

			// Get subtypes list
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getProcedureSubTypesList',
				params: {opcoId: $scope.entry.currentUser.userOpcoId, type: $scope.procedure.TYPE}
			}).then(function (response) {
				$scope.subTypes = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});

		  // Get schedules
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getSchedules',
				params: {opcoId: $scope.procedure.OPCO_ID}
			}).then(function (response) {
				$scope.schedules = response.data;
			}, function (err) {
				// handle error
				console.log(err);
			});
	  }	  
	  else {
			$http({
				method: 'GET',
				url: '/api/dfl-procedures/getProcedure',
				params: {procedureId: $stateParams.procedureId}
			}).then(function (response) {
				$scope.procedure = response.data;
				// console.log($scope.procedure);

				$scope.procedure.CONTROL_ASSERTION = JSON.parse($scope.procedure.CONTROL_ASSERTION);
				$scope.procedure.START_DATE = ($scope.procedure.START_DATE?moment($scope.procedure.START_DATE).toDate():null);
				$scope.procedure.END_DATE = ($scope.procedure.END_DATE?moment($scope.procedure.END_DATE).toDate():null);

				// if edit dato
				if ($scope.procedure.TYPE === 'T') {
			    // Dato.getNotLinkedDatos($scope.entry.currentUser.userOpcoId).then(function (data) {
			    //   $scope.datos = data;
			    //   $scope.datos.push({DATO_ID:$scope.procedure.NAME});
			    // });	  			
				}

    		// update elastic fields
		    setTimeout (function () {
		      $scope.$broadcast('elastic:adjust');
		    }, 500); 

				// If procedure is from another OPCO, switch selected opco and disable editing
				if (Number($scope.procedure.OPCO_ID) !== $scope.entry.currentUser.userOpcoId) {
					$scope.entry.OPCO_ID = Number($scope.procedure.OPCO_ID);
					$scope.isDisabled = $scope.entry.isDisabled();
				}

				// Get subtypes list
				$http({
					method: 'GET',
					url: '/api/dfl-procedures/getProcedureSubTypesList',
					params: {opcoId: $scope.procedure.OPCO_ID, type: $scope.procedure.TYPE}
				}).then(function (response) {
					$scope.subTypes = response.data;
				}, function (err) {
					// handle error
					console.log(err);
				});

				// Get linked datasources
				$http({
					method: 'GET',
					url: '/api/dfl-procedures/getLinkedDatasources',
					params: {procedureId: $stateParams.procedureId, getDirection: 'A'}
				}).then(function (response) {
					$scope.procedure.links = response.data;
				}, function (err) {
					// handle error
					console.log(err);
				});

				// Get coverage info
				Coverage.getControlDetails($scope.procedure.CVG_CONTROL_ID)
				.then(function (response) {
					$scope.coverage = response;

					if ($scope.coverage.length > 0) {
						var productSegmentId = 0;
						var riskId = 0;
						var active = 0;

						for (var i=0; i<$scope.coverage.length;i++) {
							if (productSegmentId == $scope.coverage[i].PRODUCT_SEGMENT_ID && riskId == $scope.coverage[i].RISK_ID) {
								active = active+1;
							}
							else {
								active = 0;
							}

							$scope.coverage[i].active = active;

							productSegmentId = $scope.coverage[i].PRODUCT_SEGMENT_ID;
							riskId = $scope.coverage[i].RISK_ID;							
						}
					}
				}, function (err) {
					// handle error
					console.log(err);
				});

				// Get schedules
				$http({
					method: 'GET',
					url: '/api/dfl-procedures/getSchedules',
					params: {opcoId: $scope.procedure.OPCO_ID}
				}).then(function (response) {
					$scope.schedules = response.data;
				}, function (err) {
					// handle error
					console.log(err);
				});
				
			}, function (err) {
				// handle error
				console.log(err);
			});

	  }

		var updateProcedure = function() {
				$http({
					method: 'POST',
					url: '/api/dfl-procedures/saveProcedure',
					data: $scope.procedure
				}).then(function (response) {
					if (!response.data.success) {	
						if (response.data.error.code === 'ER_DUP_ENTRY') {
							Entry.showToast('Save failed! Procedure with the same name and type already exists');
						}
						else {
							Entry.showToast('Save failed! Error ' + JSON.stringify(response.data.error));
						}					
					}

				}, function (err) {
					console.log(err);
				});				
		};


		$scope.datoChanged = function() {

	    // Dato.getDatoInfo($scope.procedure.OPCO_ID, $scope.procedure.NAME).then(function (data) {
	    //   //$scope.dato = data;

	    //   $scope.procedure.DESCRIPTION = data.DESCRIPTION;
	    // });
		};

		$scope.save = function() {
			if (!$scope.datoForm.$valid) {
	       Entry.showToast('Please enter all required fields!');
			}
			else {
				$http({
					method: 'POST',
					url: '/api/dfl-procedures/saveProcedure',
					data: $scope.procedure
				}).then(function (response) {
					if (response.data.success) {	
						Entry.showToast('All changes saved!');
						$state.go('procedureTable', {opcoId: $scope.procedure.OPCO_ID});
					}
					else {

							if (response.data.error.code === 'ER_DUP_ENTRY') {
								Entry.showToast('Save failed! Procedure with the same name and type already exists.');
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
			$state.go('procedureTable', {opcoId: $scope.procedure.OPCO_ID});			
		};

		$scope.clone = function(){
			$scope.procedure.NAME = $scope.procedure.NAME + '_Clone';
			delete $scope.procedure.PROCEDURE_ID;
			$scope.procedure.links = [];
			
			// for (var i = 0; i<$scope.procedure.links.length; i++) {
			// 	delete $scope.procedure.links[i].PROCEDURE_ID;
			// }
		};

		$scope.delete = function() {

			var confirmationText = 'Are you sure you want to delete procedure "';
			if ($scope.procedure.TYPE === 'T') {
				confirmationText = 'Are you sure you want to unlink dato "';
			}

      ConfirmModal(confirmationText + $scope.procedure.NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
					$http({
						method: 'DELETE',
						url: '/api/dfl-procedures/deleteProcedure',
						params: {procedureId: $stateParams.procedureId}
					}).then(function (response) {
						if (response.data.success) {	
							Entry.showToast('Procedure deleted!');
							$state.go('procedureTable', {opcoId: $scope.procedure.OPCO_ID});			
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
        Entry.showToast('Delete action canceled' + err);
      });   

		};

		$scope.linkDatasource = function (linkDirection) {

			// Prepare array with datasourceIds that are already linked to the "linkDirection" side 
			var hideDatasources = _.pluck(_.filter($scope.procedure.links, function(item) {return item.DIRECTION === linkDirection ;}), 'DATASOURCE_ID');

	    dflLinkDatasourceModal(hideDatasources).then(function (datasourceId) {
				$http({
					method: 'GET',
					url: '/api/dfl-datasources/getDatasource',
					params: {datasourceId: datasourceId}
				}).then(function (response) {
					var newLinkedDatasource = {};
					newLinkedDatasource = response.data;
		      newLinkedDatasource.PROCEDURE_ID = $scope.procedure.PROCEDURE_ID;
		      newLinkedDatasource.DIRECTION = linkDirection;
		      $scope.procedure.links.push(newLinkedDatasource);
		      
		      // Save datasource links if procedure update (not new or clone)
					if ($scope.procedure.PROCEDURE_ID) {
						updateProcedure();
	    			Entry.showToast('' + newLinkedDatasource.TYPE_TEXT +  ' "' + newLinkedDatasource.NAME + '" linked to ' + (linkDirection === 'I'?'Input':'Output') + '! All changes saved!'); 
					}
					else {
	    			Entry.showToast('' + newLinkedDatasource.TYPE_TEXT +  ' "' + newLinkedDatasource.NAME + '" linked to ' + (linkDirection === 'I'?'Input':'Output') + '! Changes need to be explicitely saved!'); 
					}

				}, function (err) {
					// handle error
					console.log(err);
				});
	    }).catch(function (err) {
	    	Entry.showToast('Error ' + err); 
	    });

		};

		$scope.unlinkDatasource = function(datasourceId, linkDirection) {
			// $scope.procedure.unlinks.push(_.filter($scope.procedure.links, function(item) {return item.DATASOURCE_ID == datasourceId && item.DIRECTION == linkDirection;}));

				$http({
					method: 'GET',
					url: '/api/dfl-datasources/getDatasource',
					params: {datasourceId: datasourceId}
				}).then(function (response) {
					
					var newUnLinkedDatasource = {};
					newUnLinkedDatasource = response.data;
					$scope.procedure.links = _.reject($scope.procedure.links, function(item) {return item.DATASOURCE_ID == datasourceId && item.DIRECTION == linkDirection;});
		      
		      // Save datasource links if procedure update (not new or clone)
					if ($scope.procedure.PROCEDURE_ID) {
						updateProcedure();
	    			Entry.showToast('' + newUnLinkedDatasource.TYPE_TEXT +  ' "' + newUnLinkedDatasource.NAME + '" un-linked from ' + (linkDirection === 'I'?'Input':'Output') + '! . All changes saved!'); 
					}
					else {
	    			Entry.showToast('' + newUnLinkedDatasource.TYPE_TEXT +  ' "' + newUnLinkedDatasource.NAME + '" un-linked from ' + (linkDirection === 'I'?'Input':'Output') + '! . Changes need to be explicitely saved!'); 
					}

				}, function (err) {
					// handle error
					console.log(err);
				});		
		};

		$scope.normalizeName = function(){
			$scope.procedure.NAME = $scope.procedure.NAME && $scope.procedure.NAME.replace(' ', '_');
		};

		$scope.getColor = function(str) {
			var colorHash = new window.ColorHash();
			return colorHash.hex(str);
		};

		$scope.riskNodeClick = function(riskNode) {
			$state.go('riskNodeTable', {productSegmentId: riskNode.PRODUCT_SEGMENT_ID, riskId: riskNode.RISK_ID, tabId: riskNode.active}, {reload: true});
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
  .component('procedureInfo', {
    templateUrl: 'app/dataflow/routes/procedureInfo/procedureInfo.html',
    controller: ProcedureInfoComponent,
    controllerAs: 'procedureInfoCtrl'
  });

})();
