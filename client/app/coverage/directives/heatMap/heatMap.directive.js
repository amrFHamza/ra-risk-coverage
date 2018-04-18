'use strict';

angular.module('amxApp')
  .directive('heatMap', function ($location, $window) {
    return {
      template: '<div id="heatMap"></div>',
      restrict: 'E',
      scope: {
        config: '='
      },
      transclude: true,
      replace: false,
      link: function (scope, element, attrs) {
        var d3 = window.d3;


	        var normalizeConfig = function(inConfig) {
	        	var config = {};

	        	config.rowLabel = [];
	        	config.colLabel = [];
	        	config.data = [];
	        	config.hcrow = [];
	        	config.hccol = [];

	        	config.minValue = null;
	        	config.maxValue = null;

	        	config.rowLabelMaxLength = 0;
	        	config.colLabelMaxLength = 0;

	        	var row = 0;
	        	var col = 0;

	        	for (var i=0; i<inConfig.length; i++) {

	        		config.minValue = Math.min(inConfig[i].VALUE, (config.minValue === null)?Number(inConfig[i].VALUE):config.minValue);
	        		config.maxValue = Math.max(inConfig[i].VALUE, (config.maxValue === null)?Number(inConfig[i].VALUE):config.maxValue);

	        		if (isNaN(config.maxValue)) {
	        			console.log(inConfig[i]);
	        		}

	        		row = config.rowLabel.indexOf(inConfig[i].X) + 1;
	        		col = config.colLabel.indexOf(inConfig[i].Y) + 1;

	        		if (!row) {
	        			config.rowLabel.push(inConfig[i].X);
	        			config.rowLabelMaxLength = Math.max(config.rowLabelMaxLength, inConfig[i].X.length);
	        			row = config.rowLabel.length;
	        			config.hcrow.push(row);
	        		}

	        		if (!col) {
	        			config.colLabel.push(inConfig[i].Y);
	        			config.colLabelMaxLength = Math.max(config.colLabelMaxLength, inConfig[i].Y.length);
	        			col = config.colLabel.length;
	        			config.hccol.push(col);
	        		}

	        		if (inConfig[i].VALUE) {
	        			config.data.push({row:row, col:col, value:inConfig[i].VALUE});
	        		}

	        	}

	        	config.rowNumber = config.rowLabel.length;
	        	config.colNumber = config.colLabel.length;

	        	return config;
	        };

        function update() {

					d3.select('svg').remove();

	        // var height = $window.innerHeight - margin.top - margin.bottom - 200;
	        var config = normalizeConfig(scope.config.data);
	        var margin = {top: Math.min(8 * config.colLabelMaxLength, 450), right: 20, bottom: 20, left: Math.min(8 * config.rowLabelMaxLength, 450)};
	        // var width = 2000;

					var colNumber = config.colNumber;
					var rowNumber = config.rowNumber;

					var hcrow = scope.config.initialSort.col.length?scope.config.initialSort.col:config.hcrow;
					var hccol = scope.config.initialSort.row.length?scope.config.initialSort.row:config.hccol;

					var rowLabel = config.rowLabel;
					var colLabel = config.colLabel;
					var data = config.data;

					var maxValue = scope.config.maxValue === null?config.maxValue:scope.config.maxValue;
					var minValue = scope.config.minValue === null?config.minValue:scope.config.minValue;

					// console.log(minValue, maxValue);
					// var minValue, maxValue;
					// if (scope.config.mapValue == 'Controls') {
					// 	// take calculated min/max
					// 	maxValue = config.maxValue;
					// 	minValue = config.minValue;
					// }
					// else if (scope.config.initialSort.maxValue !== null && scope.config.initialSort.maxValue !== null) {
					// 	// take stored min/max
					// 	maxValue = scope.config.initialSort.maxValue;
					// 	minValue = scope.config.initialSort.minValue;
					// }
					// else {
					// 	// report has changed - take calculated min/max and store for future 
					// 	maxValue = config.maxValue;
					// 	scope.config.initialSort.maxValue	= maxValue;
					// 	minValue = config.minValue;						
					// 	scope.config.initialSort.minValue	= minValue;
					// }

					var cellMinimumSize = 17;
					var cellMaximumSize = 17;

					var cellMargin = 3;
	        var width = $window.innerWidth - margin.left - margin.right - 350 - colNumber*cellMargin;
					var cellSize = Math.min(Math.max(Math.floor(width/colNumber), cellMinimumSize), cellMaximumSize);
					var height = (cellSize + cellMargin) * rowNumber; // - margin.top - margin.bottom,
					width = (cellSize + cellMargin) * colNumber;

					// Red palette
					// https://gka.github.io/palettes/#colors=#ffffcc,coral,OrangeRed,maroon|steps=25|bez=0|coL=1
					var colors = ['#ffffcc','#fff4c0','#ffe9b5','#ffdda8','#ffd19d','#ffc591','#ffb985','#ffac79','#ffa06d','#ff9361','#ff8454','#ff7543','#ff652f','#ff5115','#f84200','#ec3c01','#e03602','#d33002','#c62a03','#bb2403','#ae1d03','#a21603','#970f03','#8b0702','#800000'];
					
					// Set Geen / Grey scheme for binary 
					if (minValue === 1 && maxValue == 2) {
						colors = ['#f5f5f5','#27ae60'];
					}

					var colorScale = d3.scale.quantile()
					    .domain([minValue, maxValue])
					    .range(colors);

					var svg = d3.select('#heatMap').append('svg')
					    .attr('width', width + margin.left + margin.right)
					    .attr('height', height + margin.top + margin.bottom)
						  .append('g')
						    .attr('transform', 
						          'translate(' + margin.left + ',' + margin.top + ')');

				  var rowSortOrder=true;
				  var colSortOrder=true;

					var rowLabels = svg.append('g')
					    .selectAll('.rowLabelg')
					    .data(rowLabel)
					    .enter()
					    .append('text')
					    .text(function (d) { return d; })
					    .attr('x', 0)
					    .attr('y', function (d, i) { return hcrow.indexOf(i+1) * (cellSize + cellMargin); })
					    .style('text-anchor', 'end')
					    .attr('transform', 'translate(-6,' + (cellSize + cellMargin)/2 + ')')
					    .attr('class', function (d,i) { return 'rowLabel rowLabelDesc mono r'+i;} ) 
					    .on('mouseover', function(d) {d3.select(this).classed('text-hover',true);})
					    .on('mouseout' , function(d) {d3.select(this).classed('text-hover',false);})
					    .on('click', function(d,i) {
					    	rowSortOrder=!rowSortOrder; 
					    	sortbylabel('r',i,rowSortOrder);
					    	d3.select('#order').property('selectedIndex', 4).node();
					    	d3.selectAll('.rowLabel').attr('class', function (d,i) { return 'rowLabel rowLabel'+ (rowSortOrder?'Desc':'Asc') + ' mono r'+i;}); 
					    });

					var colLabels = svg.append('g')
					    .selectAll('.colLabelg')
					    .data(colLabel)
					    .enter()
					    .append('text')
					    .text(function (d) { return d; })
					    .attr('x', 0)
					    .attr('y', function (d, i) { return hccol.indexOf(i+1) * (cellSize + cellMargin); })
					    .style('text-anchor', 'left')
					    .attr('transform', 'translate(' + (cellSize + cellMargin)/2 + ',-6) rotate (-90)')
					    .attr('class',  function (d,i) { return 'colLabel colLabelDesc mono c'+i;} )
					    .on('mouseover', function(d) {d3.select(this).classed('text-hover',true);})
					    .on('mouseout' , function(d) {d3.select(this).classed('text-hover',false);})
					    .on('click', function(d,i) {
					    	colSortOrder=!colSortOrder;  
					    	sortbylabel('c',i,colSortOrder);
					    	d3.select('#order').property('selectedIndex', 4).node();
					    	d3.selectAll('.colLabel').attr('class', function (d,i) { return 'colLabel colLabel'+ (colSortOrder?'Desc':'Asc') + ' mono r'+i;}); 
					    });

					var heatMap = svg.append('g').attr('class','g3')
					    .selectAll('.cellg')
					    .data(data, function(d){return d.row+':'+d.col;})
					    .enter()
					    .append('rect')					    
					    .attr('x', function(d) { return hccol.indexOf(d.col) * (cellSize + cellMargin) ; })
					    .attr('y', function(d) { return hcrow.indexOf(d.row) * (cellSize + cellMargin) ; })
					    .attr('class', function(d){return 'cell cell-border cr'+(d.row-1)+' cc'+(d.col-1);})
					    .attr('width', cellSize)
					    .attr('height', cellSize)
					    .style('fill', function(d) { return colorScale(d.value); })
					    .on('mouseover', function(d){
					           //highlight text
					           d3.select(this).classed('cell-hover',true);
					           d3.selectAll('.rowLabel').classed('text-highlight',function(r,ri){ return ri==(d.row-1);});
					           d3.selectAll('.colLabel').classed('text-highlight',function(c,ci){ return ci==(d.col-1);});
					    })
					    .on('mouseout', function(){
					           d3.select(this).classed('cell-hover',false);
					           d3.selectAll('.rowLabel').classed('text-highlight',false);
					           d3.selectAll('.colLabel').classed('text-highlight',false);
					    })
					    .on('mousedown', function(d) {
					    		console.log(d);
					    });

					    // .append('title')
					    //   .text(function(d) { return d.value; });


					function sortbylabel(rORc, i, sortOrder){

					       var t = svg.transition().duration(500);
					       var log2r=[];
					       var sorted; // sorted is zero-based index
					       d3.selectAll('.c'+rORc+i).filter(function(e){
					            log2r.push(e.value);
					          });
					       if (rORc == 'r'){ 

										sorted = _.sortBy(hccol, function(num) {
												var val = _.find(data, function(e) {return e.row==i+1 && e.col==num; });
												if (val) { return sortOrder?val.value:-1*val.value; } else { return 0; }
											});
										scope.config.initialSort.row = sorted;
										// scope.config.initialSort.row = [1,2,3];

										t.selectAll('.cell')
										 .attr('x', function(d) { return sorted.indexOf(d.col) * (cellSize+cellMargin); })
										 ;
										t.selectAll('.colLabel')
										.attr('y', function (d, i) { return sorted.indexOf(i+1) * (cellSize+cellMargin); })
										;
					       }
					       else if (rORc == 'c') { 
										
										sorted = _.sortBy(hcrow, function(num) {
												var val = _.find(data, function(e) {return e.col==i+1 && e.row==num; });
												if (val) { return sortOrder?val.value:-1*val.value; } else { return 0; }
											});
										scope.config.initialSort.col = sorted;
										//scope.config.initialSort.col = [3,2,1];


					         t.selectAll('.cell')
					           .attr('y', function(d) { return sorted.indexOf(d.row) * (cellSize+cellMargin); })
					           ;
					         t.selectAll('.rowLabel')
					          .attr('y', function (d, i) { return sorted.indexOf(i+1) * (cellSize+cellMargin); })
					         ;

					       }
					       else { 
					       		if (scope.config.initialSort.row.length) {
											sorted = scope.config.initialSort.row ;

											t.selectAll('.cell')
											 .attr('x', function(d) { return sorted.indexOf(d.col) * (cellSize+cellMargin); });

											t.selectAll('.colLabel')
											.attr('y', function (d, i) { return sorted.indexOf(i+1) * (cellSize+cellMargin); });
					       		}


					       		if (scope.config.initialSort.row.length) {
										 sorted = scope.config.initialSort.col;			       	
						         t.selectAll('.cell')
						           .attr('y', function(d) { return sorted.indexOf(d.row) * (cellSize+cellMargin); });
						         t.selectAll('.rowLabel')
						          .attr('y', function (d, i) { return sorted.indexOf(i+1) * (cellSize+cellMargin); });
						       }
					       }					       
					  }
					  // sortbylabel();

			}
      // Broadcast listener
      scope.$on('heatMapUpdate',function(event, data){
      	// console.log('Update diagram request!');
        update();
      });  

      }
    };
  });
