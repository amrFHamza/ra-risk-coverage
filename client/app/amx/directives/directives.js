'use strict';
/* globals MathJax, CalHeatMap */


// Focus cursor 
angular.module('amxApp').directive('focusMe', ['$timeout', function($timeout) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      scope.$watch(attrs.focusMe, function(value) {
        if(value === true) { 
          //$timeout(function() {
            element[0].focus();
            scope[attrs.focusMe] = false;
          //});
        }
      });
    }
  };
}]);

// Required to render math formulas
angular.module('amxApp').directive('math', function() {
	return {
		restrict: 'EA',
		scope: {
			math: '@'
		},
		link: function(scope, elem, attrs) {
			scope.$watch('math', function(value) {
				if (!value) {return;}
				elem.html(value);
				MathJax.Hub.Queue(['Typeset', MathJax.Hub, elem[0]]);
			});
		}
	};
});

angular.module('amxApp').directive('metricResultsBox', ['$state', 'Entry', function($state, Entry){
	// Runs during compile
	return {
		// name: '',
		// priority: 1,
		// terminal: true,
		scope: {metric: '='}, // {} = isolate, true = child, false/undefined = no change
		// controller: function($scope, $element, $attrs, $transclude) {},
		// require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
		restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
		// template: '',
		templateUrl: 'app/amx/routes/metricResultsOverview/metricResultsOverviewBoxTemplate.html',
		// replace: true,
		// transclude: true,
		// compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
		link: function($scope, iElm, iAttrs, controller) {
			
			$scope.entry = Entry;

			iElm.bind('mouseenter', function() {
					iElm.children().addClass('md-whiteframe-4dp');
					//console.log(iElm.children());
			});

			iElm.bind('mouseleave', function() {
					iElm.children().removeClass('md-whiteframe-4dp');
			});

			iElm.bind('click', function() {
					// console.log($scope.metric);

					iElm.children().removeClass('md-whiteframe-4dp');
					var currentOpcoId = $scope.metric.OPCO_ID;
					if (currentOpcoId === 0 && $scope.entry.currentUser.userOpcoId === 0) {
						currentOpcoId = 36; 
					}
					else if (currentOpcoId === 0 && $scope.entry.currentUser.userOpcoId !== 0) {
						currentOpcoId = $scope.entry.currentUser.userOpcoId;
					}
					return $state.go('metricResult', {opcoId: currentOpcoId, metricId: $scope.metric.METRIC_ID, month: $scope.entry.searchMDmonth});
					//return $state.go('metricResult', {opcoId: currentOpcoId, metricId: $scope.metric.METRIC_ID, metricDate: $scope.metric.DATE});
			});				
		}
	};
}]);

angular.module('amxApp').directive('datoResultsBox', ['$state', 'Entry', function($state, Entry){
	// Runs during compile
	return {
		// name: '',
		// priority: 1,
		// terminal: true,
		scope: {dato: '='}, // {} = isolate, true = child, false/undefined = no change
		// controller: function($scope, $element, $attrs, $transclude) {},
		// require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
		restrict: 'E', // E = Element, A = Attribute, C = Class, M = Comment
		// template: '',
		templateUrl: 'app/amx/routes/datoResultsOverview/datoResultsOverviewBoxTemplate.html',
		// replace: true,
		// transclude: true,
		// compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
		link: function($scope, iElm, iAttrs, controller) {
			
			$scope.entry = Entry;

			iElm.bind('mouseenter', function() {
					iElm.children().addClass('md-whiteframe-4dp');
					//console.log(iElm.children());
			});

			iElm.bind('mouseleave', function() {
					iElm.children().removeClass('md-whiteframe-4dp');
			});

			iElm.bind('click', function() {
					iElm.children().removeClass('md-whiteframe-4dp');
					var currentOpcoId = $scope.dato.OPCO_ID;
					if (currentOpcoId === 0 && $scope.entry.currentUser.userOpcoId === 0) {
						currentOpcoId = 36; 
					}
					else if (currentOpcoId === 0 && $scope.entry.currentUser.userOpcoId !== 0) {
						currentOpcoId = $scope.entry.currentUser.userOpcoId;
					}

					return $state.go('datoResult', {opcoId: currentOpcoId, datoId: $scope.dato.DATO_ID, month: $scope.entry.searchMDmonth});
			});				
		}
	};
}]);

angular.module('amxApp').directive('calHeatmapNew', function(){
	// Runs during compile
	return {
					restrict: 'E',
					scope: {
							config: '=',
							data: '='
					},
					link: function($scope, element, attrs, controller) {
						var cal = null;

            var refreshData = function() {
                  //console.log('Refresh data called!');
                  cal.update($scope.data);
                };

            var config = $scope.config || {};
            //var element = el[0];
            //var data = $scope.data;
            //var cal = new CalHeatMap();
						var defaults = {
								itemSelector: element[0],
								domain: 'year',
								subDomain: 'month',
								subDomainTextFormat: function(date) { return moment(date).format('MMM'); },
								afterLoadPreviousDomain: function(date) { 
																						//console.log('Prev domain loaded!');
																						setTimeout (function () {
																							refreshData();
																						},1000);
																					},
								afterLoadNextDomain: function(date) { 
																						//console.log('Next domain loaded!');
																						setTimeout (function () {
																							refreshData();
																						},1000);
																					},																				
								data: '',
								start: new Date() ,
								cellSize: 50,
								range: 1,
								domainGutter: 10,
								displayLegend: false
						};
						angular.extend(defaults, config);
						//cal.init(defaults);
						
						$scope.$on('calHeatmapUpdate',function(event, data){
							if(cal) {
                cal.destroy();
              }
							cal = new CalHeatMap();
							angular.extend(defaults, $scope.config);
							cal.init(defaults);
							cal.update($scope.data);
							//console.log('calHeatmapUpdate - received!')
         		});	

						// element.bind('click', function() {
						// 	refreshData();
						// 	//cal.update($scope.data);
						// });         								

					}
	};
});

angular.module('amxApp').directive('calHeatmap', function () {

		function link(scope, el) {
				var config = scope.config || {};
				var element = el[0];
				var cal = new CalHeatMap();
				var defaults = {
						itemSelector: element,
						domain: 'year',
						subDomain: 'day',
						subDomainTextFormat: '%d',
						data: '',
						start: new Date() ,
						cellSize: 20,
						range: 1,
						domainGutter: 10,
						legend: [2, 4, 6, 8, 10],
						itemName: 'item',
						displayLegend: false
				};
				angular.extend(defaults, config);
				cal.init(defaults);
		}
		return {
				template: '<div class="cal-heatmap" config="config"></div>',
				restrict: 'E',
				link: link,
				scope: {
						config: '='
				}
		};
});

