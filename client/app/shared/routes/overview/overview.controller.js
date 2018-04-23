'use strict';

(function(){

class OverviewComponent {
  constructor($scope, Entry, Coverage, $state, $stateParams, ConfirmModal) {
    $scope.entry = Entry;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope.loadFinished = false;

    $scope.total = {};
    $scope.lobs = [];
    $scope.productSegments = [];
    $scope.productGroups = [];

    // Set OPCO if not provided
	  if ($stateParams.opcoId === undefined) {
	    $state.go('overview', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
	  }

	  // Sankey Diagram
		$scope.sankeyDiagramConfig = {};
		$scope.sankeyDiagramConfig.links = [];
    $scope.sankeyDiagramConfig.units = $scope.entry.lookup.getOpcoById($scope.entry.OPCO_ID).CURRENCY;
    $scope.sankeyDiagramConfig.width = 'window';

    var cvgOverviewChartOptions = {
      padding: {
          top: 0,
          right: 20,
          bottom: 20,
          left: 220,
      },    
      size: {height: 100},
      legend: {show: true},
      data: {
        x : 'x',
        rows: [],
        type: 'bar',
        groups: [['RPN Residual', 'RPN Covered'], ['Value Residual', 'Value Covered']],
        order: null,
        labels: {}
      },
      color: {
        pattern: ['#27AE60', '#D9D31C', '#E74C3C', '#E7A23C', '#DDDDDD', '#428BCA']
      },
      axis: {
            rotated: true,
            x: {
                type: 'categorized',
                tick: {multiline: false, rotate: 0}
              },      
            y: {
                //label: "%",
                //position: 'inner-center',
                //show: true,                  
                tick: {
                  format: function (d) { return Number(d).toFixed(0); },
                  fit: true
                },
                min: 0,
                padding: {top:0, bottom:0},
              }
      },
      tooltip: {
          show: true,
          grouped: true // Default true
      },
      grid: {
        lines: {
          front: false
        },
        x: {
            show: false,
            lines: [
                {value: 'Postpaid Recurring fees', text: 'Postpaid', position: 'end'},
                {value: 'Prepaid One time charges', text: 'Prepaid', position: 'end'},
                {value: 'Wholesale Interconnection Fixnet', text: 'Wholesale', position: 'end'},
                {value: 'Special Billing Projects', text: 'Special Billing', position: 'end'},
            ]          
        },
        y: {
          show: true
        }
      }    
    };

    $scope.cvgOverviewChartOptionsTotal = angular.copy(cvgOverviewChartOptions);

    $scope.cvgOverviewChartOptionsLOB = angular.copy(cvgOverviewChartOptions);

    $scope.cvgOverviewChartOptionsPG = angular.copy(cvgOverviewChartOptions);

    Coverage.getSankeyOverview($stateParams.opcoId).then(function(data) {
      $scope.sankeyDiagramConfig.links = _.filter(data, function(e) { return e.value > 0; });
      $scope.$broadcast('sankeyDiagramUpdate',{});
      $scope.loadFinished = true;
    });


    Coverage.getProductSegments($stateParams.opcoId)
      .then(function(data){
        $scope.productSegments = data;
        //$scope.productSegments.forEach(function(e){e.COVERAGE = Math.floor(Math.random() * 100 + 1);})
        $scope.total = _.map(_.groupBy(data, 'OPCO_ID'), function(g) {
          return { 
              TOTAL_PS_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
              TOTAL_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
              TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
              TOTAL_RISK_NODE_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
              TOTAL_RPN: _.reduce(g, function(m,x) { return m + x.RPN_COUNT; }, 0),
              TOTAL_VALUE_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_TOTAL_VALUE_RATIO/100; }, 0),
              TOTAL_RPN_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.RPN_COUNT/100; }, 0)
            };
        })[0];

        $scope.lobs = _.map(_.groupBy(data, 'LOB'), function(g) {
          return { 
              LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
              PS_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
              LOB_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
              LOB_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
              LOB_RISK_NODE_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
              LOB_RPN: _.reduce(g, function(m,x) { return m + x.RPN_COUNT; }, 0),              
              LOB_VALUE_COVERAGE_P: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_LOB_VALUE_RATIO/100; }, 0),
              LOB_VALUE_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_VALUE/100; }, 0),
              LOB_RPN_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.RPN_COUNT/100; }, 0)              
            };
        });

        $scope.productGroups = _.map(_.groupBy(data, 'PRODUCT_GROUP_ID'), function(g) {
          return { 
              LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
              PG: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP; }, 0),
              PG_ID: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP_ID; }, 0),
              PS_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
              PG_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
              PG_RPN: _.reduce(g, function(m,x) { return m + x.RPN_COUNT; }, 0),              
              PG_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
              PG_RISK_NODE_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
              PG_VALUE_COVERAGE_P: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_GROUP_VALUE_RATIO/100; }, 0),
              PG_VALUE_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_VALUE/100; }, 0),              
              PG_RPN_COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.RPN_COUNT/100; }, 0)              
            };
        });

        // console.log($scope.total);
        // console.log($scope.lobs);
        // console.log($scope.productGroups);
        // console.log($scope.productSegments);
        $scope.loadFinished = true;

        // Value total chart
        $scope.cvgOverviewDailyChartDataTotal = [];
        $scope.cvgOverviewDailyChartDataTotal.push(['x', 'Value Covered', 'Value Residual']);

        $scope.cvgOverviewDailyChartDataTotal.push(['All', $scope.total.TOTAL_VALUE_COVERAGE, 100-$scope.total.TOTAL_VALUE_COVERAGE]);

        $scope.cvgOverviewChartOptionsTotal.legend.show = false;
        $scope.cvgOverviewChartOptionsTotal.tooltip.show = false;
        $scope.cvgOverviewChartOptionsTotal.size.height = 90;
        $scope.cvgOverviewChartOptionsTotal.axis.y.max = 100;
        $scope.cvgOverviewChartOptionsTotal.axis.y.tick.format = function (d) { return Number(d).toFixed(2) + '  %'; };
        $scope.cvgOverviewChartOptionsTotal.data.labels.format = function (d) { return Number(d).toFixed(2) + '  %'; };

        // Value LoB chart
        $scope.cvgOverviewDailyChartDataLOB = [];
        $scope.cvgOverviewDailyChartDataLOB.push(['x', 'Value Covered', 'Value Residual']);
        for (var i=0; i<$scope.lobs.length; i++) {
          $scope.cvgOverviewDailyChartDataLOB.push([$scope.lobs[i].LOB, $scope.lobs[i].LOB_VALUE_COVERAGE, $scope.lobs[i].LOB_VALUE - $scope.lobs[i].LOB_VALUE_COVERAGE]);
        }
        $scope.cvgOverviewChartOptionsLOB.size.height = 185;
        $scope.cvgOverviewChartOptionsLOB.axis.y.max = _.max($scope.lobs, function(e){ return e.LOB_VALUE; }).LOB_VALUE;
        $scope.cvgOverviewChartOptionsLOB.axis.y.tick.format = function (d) { return Number(d/1000000).toFixed(2); };
        $scope.cvgOverviewChartOptionsLOB.axis.y.label = '\'M ' + $scope.sankeyDiagramConfig.units;
        $scope.cvgOverviewChartOptionsLOB.data.labels.format = function (v, l, i, j) { 
          if (l === 'Value Covered') {
            return Number(($scope.cvgOverviewDailyChartDataLOB[i+1][1]*100) / ($scope.cvgOverviewDailyChartDataLOB[i+1][1] + $scope.cvgOverviewDailyChartDataLOB[i+1][2])).toFixed(2) + ' %';
          }
        };

        // Value Product groups chart
        $scope.cvgOverviewDailyChartDataPG = [];
        $scope.cvgOverviewDailyChartDataPG.push(['x', 'Value Covered', 'Value Residual']);
        for (i=0; i<$scope.productGroups.length; i++) {
          $scope.cvgOverviewDailyChartDataPG.push([$scope.productGroups[i].LOB + ' ' + $scope.productGroups[i].PG, $scope.productGroups[i].PG_VALUE_COVERAGE, $scope.productGroups[i].PG_VALUE - $scope.productGroups[i].PG_VALUE_COVERAGE]);
        }

        $scope.cvgOverviewChartOptionsPG.size.height = 600;        
        $scope.cvgOverviewChartOptionsPG.axis.y.max = $scope.cvgOverviewChartOptionsLOB.axis.y.max;
        $scope.cvgOverviewChartOptionsPG.axis.y.tick.format = function (d) { return Number(d/1000000).toFixed(2); };
        $scope.cvgOverviewChartOptionsPG.axis.y.label = '\'M ' + $scope.sankeyDiagramConfig.units;

        //Update chart
        setTimeout (function () {
          $scope.$broadcast('c3ChartUpdate',{}); 
        }, 100); 

    });

	  // Reload OPCO_ID change
	  $scope.$watch('entry.OPCO_ID', function(){
	    setTimeout (function () {
	      $state.go('overview', {opcoId: $scope.entry.OPCO_ID} );
	    }, 100); 
	  });
  }
}

angular.module('amxApp')
  .component('overview', {
    templateUrl: 'app/shared/routes/overview/overview.html',
    controller: OverviewComponent,
    controllerAs: 'OverviewCtrl'
  });

})();
