'use strict';

angular.module('amxApp')
  .directive('sankeyDiagram', function ($location, $window) {
    return {
      // templateUrl: 'app/dataflow/directives/directedGraph/directedGraph.html',
      template: '<div id="sankeyDiagram"></div>',
      restrict: 'E',
      scope: {
        config: '='
      },
      transclude: true,
      replace: false,
      link: function (scope, element, attrs) {

        var d3 = window.d3;

        var margin = {top: 20, right: 20, bottom: 20, left: 20};
        var height = $window.innerHeight - margin.top - margin.bottom - 200;
        var width = 1100;

        if (scope.config.width === 'window') {
					width = $window.innerWidth - margin.left - margin.right - 300;
        }

        function redraw() {
          svg.attr('transform', 'translate(' + d3.event.translate + ')' + ' scale(' + d3.event.scale + ')');
        }

        var svg = d3.select('#sankeyDiagram').append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
					  .append('g')
					    .attr('transform', 
					          'translate(' + margin.left + ',' + margin.top + ')');
     
        function update() {

          // Clean the canvas
          svg.selectAll('*').remove();

          // Read the elements from config object
          var links = scope.config.links;
          var nodes = [];

          // Compute the distinct nodes from the links.
          links.forEach(function(link) {
            nodes.push(link.target);
            nodes.push(link.source);
          });

          nodes = _.map(_.uniq(nodes), function(e) {
          	return {'name': e};
          });

          var graph = {'nodes': nodes, 'links': links};

				  var nodeMap = {};
				  graph.nodes.forEach(function(x) { nodeMap[x.name] = x; });
				  graph.links = graph.links.map(function(x) {
				    return {
				      source: nodeMap[x.source],
				      target: nodeMap[x.target],
				      value: x.value
				    };
				  });

					// Set the sankey diagram properties
					var sankey = d3.sankey()
					    .nodeWidth(15)
					    .nodePadding(15)
					    .size([width, height]);

					var path = sankey.link();

				  sankey
				    .nodes(graph.nodes)
				    .links(graph.links)
				    .layout(32);

					var units = scope.config.units;

					var formatNumber = d3.format(',.2f'),    // zero decimal places
					    format = function(d) { return formatNumber(d) + ' ' + units; },
					    formatPercent = function(d) { return formatNumber(d*100) + '%'; },
							color = d3.scale.category20();

					var total = d3.sum(graph.nodes, function(d) {
								if (d.targetLinks.length>0) {
									return 0; //node is not source, exclude it from the total
								}
								else {
									return d.value; //node is a source: add its value to the sum
								}
							}); 

	        // function color(node, depth) {
	        //   var id = node.id.replace(/(_score)?(_\d+)?$/, '');
	        //   if (depth > 0 && node.targetLinks && node.targetLinks.length == 1) {
	        //     return color(node.targetLinks[0].source, depth-1);
	        //   } else {
	        //     return null;
	        //   }
	        // }

					// add in the links
					  var link = svg.append('g').selectAll('.link')
					      .data(graph.links)
					    .enter().append('path')
					      .attr('class', 'sankey-link')
					      .attr('d', path)
					      .attr('id', function(d,i){
					        d.id = i;
					        return 'link-'+i;
					      })					      
					      .style('stroke-width', function(d) { return Math.max(1, d.dy); })
					      .sort(function(a, b) { return b.dy - a.dy; });

					// add the link titles
					  link.append('title')
									.style('font-family', 'Open Sans')
									.style('font-size', function(d) {return '10px'; })
					        .text(function(d) {
					            return d.source.name + ' → ' + d.target.name + '\n' + format(d.value) + ' (' + formatPercent(d.value/total) + ')';
					          });

					// add in the nodes
					  var node = svg.append('g').selectAll('.node')
					      .data(graph.nodes)
					    .enter().append('g')
					      .attr('class', 'sankey-node')
					      .attr('transform', function(d) { 
					          return 'translate(' + d.x + ',' + d.y + ')'; })
					      .on('mouseover', highlightNodeLinks)
    						.on('mouseout', unhighlightNodeLinks)
    						.on('click', clickHighlightNodeLinks)
					    .call(d3.behavior.drag()
					      .origin(function(d) { return d; })
					      .on('dragstart', function() { this.parentNode.appendChild(this); })
					      .on('drag', dragmove));

					// add the rectangles for the nodes
					  node.append('rect')
					      .attr('height', function(d) { return d.dy; })
					      .attr('width', sankey.nodeWidth())
					      .style('fill', function(d) { return color(d.name.replace(/ .*/, '')); })
					      // .style('stroke', function(d) { return d3.rgb(d.color).darker(3); })
					      .style('stroke', '#333')
					      .style('stroke-width', '1px')
					    .append('title')
					      .text(function(d) { return d.name + '\n' + format(d.value) + ' (' + formatPercent(d.value/total) + ')'; });

					// add in the title for the nodes
					  node.append('text')
              	.style('font-family', 'Open Sans')					  
					      .attr('x', -6)
					      .attr('y', function(d) { return d.dy / 2; })
					      .attr('dy', '.35em')
					      .attr('text-anchor', 'end')
					      .attr('transform', null)
								.style('font-size', function(d) {return '12px'; })
              	.style('font-weight', 'bold')					      
              	.style('text-shadow', '0 1px 0 #fff, 1px 0 0 #fff, 0 -1px 0 #fff, -1px 0 0 #fff')
					      .text(function(d) { return d.name; })
					    .filter(function(d) { return d.x < width / 2; })
					      .attr('x', 6 + sankey.nodeWidth())
					      .attr('text-anchor', 'start');

					// the function for moving the nodes
					  function dragmove(d) {
					  	/*jshint validthis: true */
					    d3.select(this).attr('transform', 
					        'translate(' + (
					            d.x = d.x //Math.max(0, Math.min(width - d.dx, d3.event.x))
					        ) + ',' + (
					            d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))
					        ) + ')');
					    sankey.relayout();
					    link.attr('d', path);
					  }

						function unhighlightNodeLinks(node, i){
						    var remainingNodes=[], nextNodes=[];
						    var strokeOpacity = 0.2;
						    var traverse = [{
						                      linkType : 'sourceLinks',
						                      nodeType : 'target'
						                    },{
						                      linkType : 'targetLinks',
						                      nodeType : 'source'
						                    }];

						    traverse.forEach(function(step){
						      node[step.linkType].forEach(function(link) {
						        remainingNodes.push(link[step.nodeType]);
						        highlightLink(link.id, strokeOpacity);
						      });
						    });

						  
						}

						function highlightNodeLinks(node, i){					
						    var remainingNodes=[], nextNodes=[];
						    var strokeOpacity = 0.5;
						    var traverse = [{
						                      linkType : 'sourceLinks',
						                      nodeType : 'target'
						                    },{
						                      linkType : 'targetLinks',
						                      nodeType : 'source'
						                    }];

						    traverse.forEach(function(step){
						      node[step.linkType].forEach(function(link) {
						        remainingNodes.push(link[step.nodeType]);
						        highlightLink(link.id, strokeOpacity);
						      });

						    });
						  }

							function clickHighlightNodeLinks(node, i){			

						    var remainingNodes=[], nextNodes=[];  
						    var strokeColor = '#000';
						    /*jshint validthis: true */
						    if( d3.select(this).attr('data-clicked') == '1' ){
						    	/*jshint validthis: true */
						      d3.select(this).attr('data-clicked','0');
						      strokeColor = '#000';
						    }else{
						    	/*jshint validthis: true */
						      d3.select(this).attr('data-clicked','1');
						      strokeColor = '#F00';
						    }

						    var traverse = [{
						                      linkType : 'sourceLinks',
						                      nodeType : 'target'
						                    },{
						                      linkType : 'targetLinks',
						                      nodeType : 'source'
						                    }];

						    traverse.forEach(function(step){
						      node[step.linkType].forEach(function(link) {
						        remainingNodes.push(link[step.nodeType]);
						        colorLink(link.id, strokeColor);
						      });

						      // K.T. Removed to avoid recursive parsing of all connected nodes

						      // while (remainingNodes.length) {
						      //   nextNodes = [];
						      //   remainingNodes.forEach(function(node) {
						      //     node[step.linkType].forEach(function(link) {
						      //       nextNodes.push(link[step.nodeType]);
						      //       highlightLink(link.id, strokeOpacity);
						      //     });
						      //   });
						      //   remainingNodes = nextNodes;
						      // }
						    });
						  }

						  function highlightLink(id,opacity){
						    d3.select('#link-'+id).style('stroke-opacity', opacity);
						  }

						  function colorLink(id,color){
						    d3.select('#link-'+id).style('stroke', color);
						  }

      } 
      update();

      // Broadcast listener
      scope.$on('sankeyDiagramUpdate',function(event, data){
      	// console.log('Update diagram request!');
        update();
      });    

      }
    };
  });
