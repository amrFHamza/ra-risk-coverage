'use strict';

(function(){

class KeyRiskAreaLandscapeComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal, Coverage, $timeout, $filter, $sce) {
    $scope.entry = Entry;
    $scope.isDisabled = (Number($scope.entry.currentUser.userOpcoId) !== 0);
    $scope.keyRiskAreas = [];
    $scope.businessProcesses = [];    
    $scope.loadFinished = false;

    $scope._ = _;

    // Set OPCO if not provided
    if ($stateParams.opcoId === undefined) {
      $state.go('keyRiskAreaLandscape', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
    }

    Coverage.getRisks().then(function(data){
        $scope.risks = data;
        $scope.businessProcesses = _.map(_.groupBy(data, 'BUSINESS_PROCESS_ID'), function(g) {
          return { 
              BUSINESS_PROCESS: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
              BUSINESS_PROCESS_ID: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS_ID; }, 0),
            };
        });
    });

		Coverage.getKeyRiskAreaLandscape($stateParams.opcoId).then(function (response) {
			// Full resultset
			$scope.keyRiskAreasData = response;

			// List of all relevant Key Risk Areas
				Coverage.getKeyRiskAreaLandscapeSums($stateParams.opcoId).then(function (response) {
					// Full resultset
					$scope.keyRiskAreas = response;
					// add CSS class

          // console.log($scope.keyRiskAreasData);
          // console.log($scope.keyRiskAreas);
					$scope.loadFinished = true;

				}, function (err) {
					// error handling
				});
				
		}, function (err) {
			// error handling
		});

	  $scope.keyRiskAreaInfo = function (keyRiskAreaId) {
	  	$state.go('keyRiskAreaInfo', {keyRiskAreaId: keyRiskAreaId} );
	  };

    $scope.removeAllFilters = function () {
      $scope.entry.searchKeyRiskArea = {};
    };

    $scope.removeFilter = function (element) {
      delete $scope.entry.searchKeyRiskArea[element];
      if (_.size($scope.entry.searchKeyRiskArea) === 0) {
        delete $scope.entry.searchKeyRiskArea;
      }
    };

    $scope.getKeyRiskArea = function(keyRiskAreaId, businessProcessesId) {
      var matchElements = _.find($scope.keyRiskAreasData, function(e) {
        return e.KEY_RISK_AREA_ID === keyRiskAreaId && e.BUSINESS_PROCESS_ID === businessProcessesId;
      });
      
      var keyRiskArea = _.find($scope.keyRiskAreas, function(e) {
        return e.KEY_RISK_AREA_ID === keyRiskAreaId;
      });

      if (typeof matchElements === 'undefined') {
        return {'CSS_CLASS': 0};
      }
      else {
        return keyRiskArea;
      }
    };

    $scope.getKeyRiskAreaDetails = function(keyRiskAreaId, businessProcessesId) {
    	var matchElements = _.find($scope.keyRiskAreasData, function(e) {
    		return e.KEY_RISK_AREA_ID === keyRiskAreaId && e.BUSINESS_PROCESS_ID === businessProcessesId;
    	});

    	if (typeof matchElements === 'undefined') {
  			return {'CSS_CLASS': 0};	
  		}
      else {
    	 return matchElements;
      }
    };

    var trusted = {};
    $scope.popoverHtmlDetails = function (keyRiskAreaId, businessProcessesId) {     
      var matchElements = _.find($scope.keyRiskAreasData, function(e) {
        return e.KEY_RISK_AREA_ID === keyRiskAreaId && e.BUSINESS_PROCESS_ID === businessProcessesId;
      });

      if (typeof matchElements === 'undefined'){
        return null;
      }
      else {
        var popoverTxt = `
        <table style="width: 150px">
        <tr>
          <td colspan='2' style="vertical-align: middle; text-align: center;" class='label-process-` + businessProcessesId + `'><strong>` + matchElements.BUSINESS_PROCESS + `</strong></td>
        </tr>
        <tr>
          <td style="vertical-align: middle; text-align: Left;">
            Distinct risks: 
          </td>
          <td style="vertical-align: middle; text-align: right;">
            <h4>
              <span class="label label-primary">` + matchElements.DISTINCT_RISKS + `</span>
            </h4>
          </td>
        </tr>
        <tr>
          <td style="vertical-align: middle; text-align: Left;">
            Risk nodes: 
          </td>
          <td style="vertical-align: middle; text-align: right;">
            <h4>
              <span class="label label-danger">` + matchElements.RISK_NODES + `</span>
            </h4>
          </td>
        </tr>
        <tr>
          <td style="vertical-align: middle; text-align: Left;">
            Controlled nodes: 
          </td>
          <td style="vertical-align: middle; text-align: right;">
            <h4>
              <span class="label label-default">` + matchElements.RISK_NODES_WITH_CONTROLS + `</span>
            </h4>
          </td>
        </tr>
        </table>
        `;

        return trusted[popoverTxt] || (trusted[popoverTxt] = $sce.trustAsHtml(popoverTxt));
      }
    };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('keyRiskAreaLandscape', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });    

    // Watch filter change
    var timer = false;
    var timeoutFilterChange = function(newValue, oldValue){
        if(timer){
          $timeout.cancel(timer);
        }
        timer = $timeout(function(){ 

          // remove filters with blank values
          $scope.entry.searchKeyRiskArea = _.pick($scope.entry.searchKeyRiskArea, function(value, key, object) {
            return value !== '' && value !== null;
          });
          
          if (_.size($scope.entry.searchKeyRiskArea) === 0) {
            //delete $scope.entry.searchKeyRiskArea;
            $scope.entry.searchKeyRiskArea = {};
          }
                
        }, 400);
    };
    $scope.$watch('entry.searchKeyRiskArea', timeoutFilterChange, true);   	  
  }
}

angular.module('amxApp')
  .component('keyRiskAreaLandscape', {
    templateUrl: 'app/coverage/routes/keyRiskAreaLandscape/keyRiskAreaLandscape.html',
    controller: KeyRiskAreaLandscapeComponent,
    controllerAs: 'keyRiskAreaLandscapeCtrl'
  });

})();
