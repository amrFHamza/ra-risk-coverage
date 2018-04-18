'use strict';

	// Group by filter
	angular.module('amxApp').filter('groupBy', ['pmkr.filterStabilize', function(stabilize){
	    return stabilize( function (data, key) {
	        if (!(data && key)) {
	        	return;
	        }
	        var result = {};
	        for (var i=0; i<data.length; i++) {
	            if (!result[data[i][key]]) {
	               result[data[i][key]]=[];
	            }
	            result[data[i][key]].push(data[i]);
	        }
	        return result;
	    });
	}])
	.factory('pmkr.filterStabilize', [
	  'pmkr.memoize',
	  function(memoize) {
	    function service(fn) {
	      function filter() {
	        var args = [].slice.call(arguments);
	        
	        // always pass a copy of the args so that the original input can't be modified
	        // args = angular.copy(args);
	        
	        // return the `fn` return value or input reference (makes `fn` return optional)

	        /*jshint validthis: true */
	        var filtered = fn.apply(this, args) || args[0];
	        return filtered;
	      }
	      var memoized = memoize(filter);
	      return memoized;
	    }
	    return service;
	  }
	])
	.factory('pmkr.memoize', [
	  function() {
	    function service() {
	    	/*jshint validthis: true */
	      return memoizeFactory.apply(this, arguments);
	    }
	    function memoizeFactory(fn) {
	      var cache = {};
	      function memoized() {
	        var args = [].slice.call(arguments);
	        var key = JSON.stringify(args);
	        var fromCache = cache[key];
	        if (fromCache) {
	          return fromCache;
	        }
	        /*jshint validthis: true */
	        cache[key] = fn.apply(this, arguments);
	        return cache[key];
	      }
	      return memoized;
	    }
	    return service;
	  }
	]);


	// Start from filter
	angular.module('amxApp').filter('startFrom', function() {
	    return function(input, start) {
	    		if (typeof input !== 'undefined') {
	        	return input.slice(start);
	    		}
	    		else {
	    			return null;
	    		}
			};
		});

	angular.module('amxApp').filter('metricTableResultsFilter', function () {
		var getColors = function (item) {
			var colors = {'GREEN': 0, 'YELLOW': 0, 'ORANGE':0, 'RED': 0, 'NO_RESULT': 0};
			for (var i = 0; i < item.length; i++) {

				if ((item[i].VALUE !== null && item[i].VALUE <= item[i].OBJECTIVE) || (item[i].VALUE > item[i].OBJECTIVE && item[i].VALUE <= item[i].OBJECTIVE + item[i].TOLERANCE && item[i].TREND == 'Y')) {
					colors.GREEN += 1;
				}
				else if (item[i].VALUE !== null && item[i].VALUE>item[i].OBJECTIVE && item[i].VALUE <= item[i].OBJECTIVE + item[i].TOLERANCE && item[i].TREND == 'N') {
					colors.YELLOW += 1;
				}
				else if (item[i].VALUE !== null && item[i].VALUE > item[i].OBJECTIVE + item[i].TOLERANCE && item[i].TREND == 'N') {
					colors.RED += 1;
					//console.log(item[i]);
				}
				else if (item[i].VALUE !== null && item[i].VALUE > item[i].OBJECTIVE + item[i].TOLERANCE && item[i].TREND == 'Y') {
					colors.ORANGE += 1;
				}
				else if (item[i].VALUE !== null && item[i].DAYS_LATE > 1) {
					colors.NO_RESULT += 1;
				}
			}
			return colors;
		};

		return function (items, inFilter) {
				var filtered = [];
				for (var i = 0; i < items.length; i++) {
					var item = items[i];
					//console.log(item[0]);
					if (typeof inFilter.text === 'undefined' || item[0].METRIC_ID.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1 || item[0].BILL_CYCLE === inFilter.text) {
						var itemColors = getColors(item);
						if (itemColors.GREEN && inFilter.GREEN) {filtered.push(item);}
						else if (itemColors.YELLOW && inFilter.YELLOW) {filtered.push(item);}
						else if (itemColors.ORANGE && inFilter.ORANGE) {filtered.push(item);}
						else if (itemColors.RED && inFilter.RED) {filtered.push(item);}
						else if (itemColors.NO_RESULT && inFilter.NO_RESULT) {filtered.push(item);}
					}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('tasklistDone', function () {
		return function (items, inFilter) {
				var filtered = [];
				if (inFilter === 'undefined' || inFilter === 'N') {
					return items;
				}
				else {
					for (var i = 0; i < items.length; i++) {
						var item = items[i];
						if (item.TASKS_TAG || item.TASKS_OPCO) {
								 filtered.push(item);
						}
					}
				return filtered;
				}
		};
});

angular.module('amxApp').filter('alarmFilter', function () {
		return function (items, inFilter) {
				var filtered = [];
				for (var i = 0; i < (typeof items !== 'undefined'?items.length:0); i++) {
						var item = items[i];
						if (typeof inFilter.text === 'undefined' || item.ALARM_ID.toString().toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1 || item.OBJECT_ID.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1 || item.ASSIGNED_TO.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1 || item.STATUS.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1 ) {
								if (item.SEVERITY_ID == 3 && inFilter.ERROR) {filtered.push(item);}
								else if (item.SEVERITY_ID == 2 && inFilter.WARNING) {filtered.push(item);}
								else if (item.SEVERITY_ID == 1 && inFilter.INFO) {filtered.push(item);}
						}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('metricResultsOverviewFilter', function () {
		return function (items, inFilter) {
				var filtered = [];
				for (var i = 0; i < items.length; i++) {
						var item = items[i];
						if ((inFilter.IMPLEMENTED && item.IMPLEMENTED === 'Y') || !inFilter.IMPLEMENTED) {
							
							if (typeof inFilter.text === 'undefined' || item.METRIC_ID.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1  || item.AREA_ID.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1) {
									if (item.GREEN && inFilter.GREEN && inFilter[item.FREQUENCY]) {filtered.push(item);}
									else if (item.YELLOW && inFilter.YELLOW && inFilter[item.FREQUENCY]) {filtered.push(item);}
									else if (item.ORANGE && inFilter.ORANGE && inFilter[item.FREQUENCY]) {filtered.push(item);}
									else if (item.RED && inFilter.RED && inFilter[item.FREQUENCY]) {filtered.push(item);}
									else if (item.NO_RESULT && inFilter.NO_RESULT && inFilter[item.FREQUENCY]) {filtered.push(item);}
							}
						}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('datoResultsOverviewFilter', function () {
		return function (items, inFilter) {
				var filtered = [];
				for (var i = 0; i < items.length; i++) {
						var item = items[i];
						if (typeof inFilter.text === 'undefined' || item.DATO_ID.indexOf(inFilter.text) !== -1  || item.AREA_ID.toLowerCase().indexOf(inFilter.text.toLowerCase()) !== -1) {
								if (item.GREEN && inFilter.GREEN && inFilter[item.FREQUENCY]) {filtered.push(item);}
								else if (item.ORANGE && inFilter.ORANGE && inFilter[item.FREQUENCY]) {filtered.push(item);}
								else if (item.RED && inFilter.RED && inFilter[item.FREQUENCY]) {filtered.push(item);}
								else if (item.NO_RESULT && inFilter.NO_RESULT && inFilter[item.FREQUENCY]) {filtered.push(item);}
						}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('opcoFilter', function () {
		return function (items, opcoId) {
				var filtered = [];
				if (typeof items === 'undefined') {return items;}
				for (var i = 0; i < items.length; i++) {
						var item = items[i];
						if (item.OPCO_ID == opcoId || opcoId === 0) {filtered.push(item);}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('changeRequestStatusFilter', function () {
		return function (items, status) {
				var filtered = [];
				for (var i = 0; i < items.length; i++) {
						var item = items[i];
						if (item.STATUS < Number(status)) {filtered.push(item);}
				}
				return filtered;
		};
});

angular.module('amxApp').filter('unsafe', function($sce) { return $sce.trustAsHtml; });

angular.module('amxApp').filter('split', function() {
		return function (items, delimiter) {
			delimiter = delimiter || ',';

			if (typeof items !== 'undefined' && items !== null) {
					return items.split(delimiter);
				}
				else {
					return items;
				}
		}; 
	});

angular.module('amxApp').filter('sentencecase', function()
{
		return function(word)	{
				return word.substring(0,1).toUpperCase() + word.slice(1).toLowerCase();
		};
});


angular.module('amxApp').filter('toArray', function () {
  return function (obj, addKey) {
    if (!(obj instanceof Object)) {
      return obj;
    }

    if ( addKey === false ) {
      return Object.values(obj);
    } else {
      return Object.keys(obj).map(function (key) {
        return Object.defineProperty(obj[key], '$key', { enumerable: false, value: key});
      });
    }
  };
});