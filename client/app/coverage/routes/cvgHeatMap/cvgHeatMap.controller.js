'use strict';

(function(){

class CvgHeatMapComponent {
  constructor($scope, Entry, Coverage, $state, $stateParams, ConfirmModal, $filter) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.loadFinished = false;

    $scope.searchHeatMap = {};
    $scope.heatMapConfig = {};

    // Set OPCO if not provided
    if ($stateParams.opcoId === undefined) {
      $scope.entry.searchHeatMap.initialSort = {'col': [], 'row': [], 'minValue': null, 'maxValue': null};
      $state.go('cvgHeatMap', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
    }
    
    Coverage.getHeatMapData($stateParams.opcoId).then(function(data) {
      $scope.data = data;
      $scope.updateFilters();
    });

    $scope.updateFilters = function(resetInitialOrder) {
  
        var sumsPS = [];

        $scope.heatMapConfig.minValue = null;
        $scope.heatMapConfig.maxValue = null;

        if (resetInitialOrder) {
           $scope.entry.searchHeatMap.initialSort.col = [];
           $scope.entry.searchHeatMap.initialSort.row = [];
        }

        if ($scope.entry.searchHeatMap.mapType === 'Risk / Segment') {
          $scope.xTitle = 'Risk';
          $scope.yTitle = 'Product segment';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.PRODUCT_SEGMENT + e.RISK; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.RISK; }, 0),
                  Y: _.reduce(g, function(m,x) { return x.PRODUCT_SEGMENT; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)
                };
            });
        }
        else if ($scope.entry.searchHeatMap.mapType === 'Process / Group') {
          $scope.xTitle = 'Business process';
          $scope.yTitle = 'Product group';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.LOB + e.PRODUCT_GROUP + e.BUSINESS_PROCESS; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS; }, 0),
                  Y: _.reduce(g, function(m,x) { return x.LOB + ' - ' + x.PRODUCT_GROUP; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)

                };
            });
        }
        else if ($scope.entry.searchHeatMap.mapType === 'Risk / Group') {
          $scope.xTitle = 'Risk';
          $scope.yTitle = 'Product group';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.LOB + e.PRODUCT_GROUP + e.RISK; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.RISK; }, 0),
                  Y: _.reduce(g, function(m,x) { return x.LOB + ' - ' + x.PRODUCT_GROUP; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)

                };
            });
        }
        else if ($scope.entry.searchHeatMap.mapType === 'Process / Segment') {
          $scope.xTitle = 'Business process';
          $scope.yTitle = 'Product segment';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.PRODUCT_SEGMENT + e.BUSINESS_PROCESS; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS + ' - ' + x.BUSINESS_SUB_PROCESS;  }, 0),
                  Y: _.reduce(g, function(m,x) { return x.PRODUCT_SEGMENT; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)
                };
            });
        }
        else if ($scope.entry.searchHeatMap.mapType === 'Process / System') {
          $scope.xTitle = 'Business process';
          $scope.yTitle = 'System';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.SYSTEM_NAME + e.BUSINESS_PROCESS + e.BUSINESS_SUB_PROCESS; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.BUSINESS_PROCESS + ' - ' + x.BUSINESS_SUB_PROCESS;  }, 0),
                  Y: _.reduce(g, function(m,x) { return x.SYSTEM_NAME; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)
                };
            });
        }
        else if ($scope.entry.searchHeatMap.mapType === 'Risk / System') {
          $scope.xTitle = 'Risk';
          $scope.yTitle = 'System';
          sumsPS = _.map(_.groupBy($scope.data, function(e) { return e.SYSTEM_NAME + e.RISK; }), 
            function(g) {
              return { 
                  X: _.reduce(g, function(m,x) { return x.RISK;  }, 0),
                  Y: _.reduce(g, function(m,x) { return x.SYSTEM_NAME; }, 0),
                  RPN_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE; }, 0),
                  RPN_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(1-x.COVERAGE/100); }, 0),
                  RPN_COVERED_VALUE: _.reduce(g, function(m,x) { return m + x.RPN_VALUE*(x.COVERAGE/100); }, 0),
                  MONETARY_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE); }, 0),
                  MONETARY_RESIDUAL_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(1-x.COVERAGE/100); }, 0),
                  MONETARY_COVERED_VALUE: _.reduce(g, function(m,x) { return m + Math.round(x.EUR_VALUE/x.RPN_VALUE)*(x.COVERAGE/100); }, 0),
                  CONTROLS_COUNT: _.reduce(g, function(m,x) { return m + x.CONTROLS_COUNT; }, 0)
                };
            });
        }
        
        if ($scope.entry.searchHeatMap.showRPN) {
          switch ($scope.entry.searchHeatMap.mapValue) {
            case 'Total': 
              _.map(sumsPS, function(e) {
                  e.VALUE = e.RPN_VALUE;
                  $scope.heatMapConfig.maxValue = Math.max(e.RPN_VALUE, ($scope.heatMapConfig.maxValue === null)?e.RPN_VALUE:$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(e.RPN_VALUE, ($scope.heatMapConfig.minValue === null)?e.RPN_VALUE:$scope.heatMapConfig.minValue);
                });
              break;
            case 'Residual':
              _.map(sumsPS, function(e) {
                  e.VALUE = e.RPN_RESIDUAL_VALUE;
                  $scope.heatMapConfig.maxValue = Math.max(e.RPN_VALUE, ($scope.heatMapConfig.maxValue === null)?e.RPN_VALUE:$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(e.RPN_VALUE, ($scope.heatMapConfig.minValue === null)?e.RPN_VALUE:$scope.heatMapConfig.minValue);
                });
              break;
            case 'Covered':
              _.map(sumsPS, function(e) {
                  e.VALUE = e.RPN_COVERED_VALUE;
                  $scope.heatMapConfig.maxValue = Math.max(e.RPN_VALUE, ($scope.heatMapConfig.maxValue === null)?e.RPN_VALUE:$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(e.RPN_VALUE, ($scope.heatMapConfig.minValue === null)?e.RPN_VALUE:$scope.heatMapConfig.minValue);
                });
              break;
            case 'Controls':
              _.map(sumsPS, function(e) {
                  e.VALUE = (e.CONTROLS_COUNT>0?2:1);
                  $scope.heatMapConfig.maxValue = 2;
                  $scope.heatMapConfig.minValue = 1;
                });
              break;
          }

        }
        else {
          switch ($scope.entry.searchHeatMap.mapValue) {
            case 'Total': 
              _.map(sumsPS, function(e) {
                  e.VALUE = Math.abs(e.MONETARY_VALUE);
                  $scope.heatMapConfig.maxValue = Math.max(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.maxValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.minValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.minValue);
                });
              break;
            case 'Residual':
              _.map(sumsPS, function(e) {
                  e.VALUE = Math.abs(e.MONETARY_RESIDUAL_VALUE);
                  $scope.heatMapConfig.maxValue = Math.max(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.maxValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.minValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.minValue);                  
                });
              break;
            case 'Covered':
              _.map(sumsPS, function(e) {
                  e.VALUE = Math.abs(e.MONETARY_COVERED_VALUE);
                  $scope.heatMapConfig.maxValue = Math.max(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.maxValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.maxValue);
                  $scope.heatMapConfig.minValue = Math.min(Math.abs(e.MONETARY_VALUE), ($scope.heatMapConfig.minValue === null)?Math.abs(e.MONETARY_VALUE):$scope.heatMapConfig.minValue);                  
                });
              break;
            case 'Controls':
              _.map(sumsPS, function(e) {
                  e.VALUE = (e.CONTROLS_COUNT>0?2:1);
                  $scope.heatMapConfig.maxValue = 2;
                  $scope.heatMapConfig.minValue = 1;
                });
              break;              
          }
        }

        // Filter - removed since input text field are comented
        sumsPS = $filter('filter') (sumsPS, {X: $scope.entry.searchHeatMap.X, Y: $scope.entry.searchHeatMap.Y});

        $scope.heatMapConfig.data = sumsPS;
        $scope.heatMapConfig.initialSort = $scope.entry.searchHeatMap.initialSort;

        $scope.loadFinished = true;
        
        setTimeout(function(){
          $scope.loadFinished = true;
          $scope.$broadcast('heatMapUpdate',{});
        }, 500);
    };

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
        $scope.entry.searchHeatMap.initialSort = {'col': [], 'row': [], 'minValue': null, 'maxValue': null};
	      $state.go('cvgHeatMap', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });
  }
}

angular.module('amxApp')
  .component('cvgHeatMap', {
    templateUrl: 'app/coverage/routes/cvgHeatMap/cvgHeatMap.html',
    controller: CvgHeatMapComponent,
    controllerAs: 'cvgHeatMapCtrl'
  });

})();
