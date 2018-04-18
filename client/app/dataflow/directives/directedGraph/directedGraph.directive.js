'use strict';

angular.module('amxApp')
  .directive('directedGraph', function ($location, $window) {
    return {
      // templateUrl: 'app/dataflow/directives/directedGraph/directedGraph.html',
      template: '<div id="directedGraph"></div>',
      restrict: 'E',
      scope: {
        config: '='
      },
      transclude: true,
      replace: false,
      link: function (scope, element, attrs) {

        var d3 = window.d3;
        
        var menu = [
            {
                title: '<i class="fa fa-fw fa-upload fa-rotate-90"></i> Show outgoing', 
                action: function(elm, d, i) {
                  if (d.objectClass === 'P') {
                    scope.config.nodeClick(d, 'O');
                  }
                  else {
                    scope.config.nodeClick(d, 'I');
                  }
                  scope.$apply();
                }
            },
            {
                title: '<i class="fa fa-fw fa-download fa-rotate-270"></i> Show incoming', 
                action: function(elm, d, i) {
                  if (d.objectClass === 'P') {
                    scope.config.nodeClick(d, 'I');
                  }
                  else {
                    scope.config.nodeClick(d, 'O');
                  }                  
                  scope.$apply();
                },
                disabled: false // optional, defaults to false
            },
            {
                title: '<i class="fa fa-fw fa-arrows-alt"></i> Show all links', 
                action: function(elm, d, i) {
                  scope.config.nodeClick(d, 'A');
                  scope.$apply();
                },
                disabled: false // optional, defaults to false
            },
        ];

        var margin = {top: 20, right: 20, bottom: 30, left: 40},
            width = $window.innerWidth - margin.left - margin.right - 700 ,
            height = $window.innerHeight - margin.top - margin.bottom - 220,
            nodeSize = 15,
            linkDistance = 100;

        function redraw() {
          svg.attr('transform',
              'translate(' + d3.event.translate + ')' + ' scale(' + d3.event.scale + ')');
        }

        var svg = d3.select('#directedGraph').append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
          .call(d3.behavior.zoom().on('zoom', redraw))
            .append('g'); 
     
        function update() {

          // Clean the canvas
          svg.selectAll('*').remove();

          // Marker arrow for line
          svg.append('defs').selectAll('marker')
              .data(['arrow-line'])
            .enter().append('marker')
              .attr('id', function(d) { return d; })
              .attr('viewBox', '0 -5 10 10')
              .attr('refX', nodeSize*1.7)
              .attr('refY', 0)
              .attr('markerWidth', 3)
              .attr('markerHeight', 3)
              .attr('orient', 'auto')
            .append('path')
              .attr('d', 'M0,-5L10,0L0,5');

          // Marker arrow for arc
          svg.append('defs').selectAll('marker')
              .data(['arrow-arc'])
            .enter().append('marker')
              .attr('id', function(d) { return d; })
              .attr('viewBox', '0 -5 10 10')
              .attr('refX', nodeSize*1.6)
              .attr('refY', -2.5)
              .attr('markerWidth', 3)
              .attr('markerHeight', 3)
              .attr('orient', 'auto')
            .append('path')
              .attr('d', 'M0,-5L10,0L0,5'); 

          // need for zoom/pan functionality
          svg.append('rect')
              .attr('class', 'rect')
              .attr('width', width)
              .attr('height', height);

          // Read the elements from config object
          var links = scope.config.links;
          var nodes = {};

          // Compute the distinct nodes from the links.
          links.forEach(function(link) {
            link.source = nodes[link.source.objectTag] || (nodes[link.source.objectTag] = link.source);
            link.target = nodes[link.target.objectTag] || (nodes[link.target.objectTag] = link.target);
          });

          // Mark bi-directional nodes so we use arcs instead of lines
          links.forEach(function(link) {
            var biDirectionalNode = _.find(links, function(obj){ return (link.target.objectTag == obj.source.objectTag) && (link.source.objectTag == obj.target.objectTag); });
            if (typeof  biDirectionalNode !== 'undefined') {
              link.biDirectional = true;
            }
          });

          var force = d3.layout.force()
              .nodes(d3.values(nodes))
              .links(d3.values(links))        
              .size([width, height])
              .linkDistance(linkDistance)
              .charge(-800)
              .gravity(0.12)
              .on('tick', tick) 
              .start();

          // Links 
          var updateLink = svg.selectAll('.link').data(force.links(), function(d) { return d.source.objectTag + '-' + d.target.objectTag; });
          updateLink.exit().remove();

          var linkEnter = updateLink.enter().append('g')
              .attr('class', 'link');

          var path = linkEnter.append('path')
              .style('opacity', 0.5)
              .style('stroke-width', '4px')
              .attr('class', function(d) { return 'link-source-' + d.source.type + ' link-target-' + d.target.type; })
              .attr('marker-end', function(d) {
                  return 'url(' + $location.$$url + ((d.biDirectional)?'#arrow-arc':'#arrow-line') + ')'; 
              });

          // Nodes
          var updateNode = svg.selectAll('.node').data(force.nodes(), function(d) { return d.objectTag;});
          updateNode.exit().remove();

          var nodeEnter = updateNode.enter().append('g')
              .attr('class', 'node')
              .call(force.drag);

          var circle = nodeEnter.append('circle')
              .attr('r', nodeSize*1.3)
              .attr('class', function(d) { return 'node-'+d.type + ((d.objectTag == scope.config.infoElement)?(' node-info'):'') + ((d.objectTag == scope.config.selectedElement)?(' node-selected'):''); })
            .on('dblclick', function(d,i){
                nodeDoubleClick(d);
              })
            .on('click', function(d,i){
                nodeClick(d);
                d3.selectAll('circle').attr('class', function(d) { return 'node-'+d.type + ((d.objectTag == scope.config.infoElement)?(' node-info'):'') + ((d.objectTag == scope.config.selectedElement)?(' node-selected'):''); });
                d3.select(this).attr('class', function(d) { return 'node-'+d.type + ((d.objectTag == scope.config.infoElement)?(' node-info'):'') + ((d.objectTag == scope.config.selectedElement)?(' node-selected'):''); });
                d3.event.stopPropagation();
              })
            .on('contextmenu', d3.contextMenu(menu)) // attach menu to element
            ; 

          var icon = nodeEnter.append('text')
              .style('font-family', 'FontAwesome')
              .style('font-size', Math.round(nodeSize*1.3) + 'px')
              .style('fill', '#333')
              .attr('stroke', '#FFF')
              .attr('stroke-width', '0px')
              .attr('vector-effect', 'non-scaling-stroke')
              .attr('x', - (nodeSize / 2 + 1))
              .attr('y', nodeSize / 2)      
            .text(function(d) { 
                                  var icon = ''; // cog
                                  switch (d.type) {
                                    case 'D': icon = '\uf1c0'; break; // Database
                                    case 'F': icon = '\uf0f6'; break; // File-o
                                    case 'E': icon = '\uf0e0'; break; // Envelope (Email)
                                    case 'T': icon = '\uf1b2'; break; // Cube (Dato)
                                    case 'R': icon = '\uf201'; break; // AMX Metric
                                    case 'C': icon = '\uf1fe'; break; // Area chart (Control / Metric)
                                    // case 'C': icon = '\uf201'; break; // Line chart (Control / Metric)
                                    case 'J': icon = '\uf013'; break; // Cogs (Job)
                                    case 'M': icon = '\uf007'; break; // User (Manual)
                                    case 'S': icon = '\uf12e'; break; // Puzzle (Solution)
                                    default: icon = '\uf085';         // Cogs - some process
                                  }
                                  return icon; 
                                });

          var text = nodeEnter.append('text')
              .style('font-family', 'Open Sans')
              .attr('x', function(d) { return nodeSize + 10 ; })
              .attr('y', function(d) { return 0; })
              .style('font-size', function(d) {return ((d.objectTag == scope.config.selectedElement)?'12px':'10px'); })
              .style('font-weight', 'bold')
              .style('text-shadow', '0 1px 0 #fff, 1px 0 0 #fff, 0 -1px 0 #fff, -1px 0 0 #fff')
            .text(function(d) { return d.name; });  

          function tick() {
            path.attr('d', drawLine);
            circle.attr('transform', transform);
            icon.attr('transform', transform);
            text.attr('transform', transform);
          }

          // Use elliptical arc for bi-directional relation between nodes
          function drawLine(d) {
            var dx = d.target.x - d.source.x,
                dy = d.target.y - d.source.y,
                dr = Math.sqrt(dx * dx + dy * dy);

              if (d.biDirectional) {
                return 'M' + d.source.x + ',' + d.source.y + 'A' + dr + ',' + dr + ' 0 0,1 ' + d.target.x + ',' + d.target.y;
              }
              else {
                return 'M' + d.source.x + ',' + d.source.y + 'L' + d.target.x + ',' + d.target.y;
              }
          }

          function transform(d) {
            return 'translate(' + d.x + ',' + d.y + ')';
          }

          function dragstarted(d) {
            d3.event.sourceEvent.stopPropagation();
            /*jshint validthis: true */
            d3.select(this).classed('dragging', true);
          }

          function dragged(d) {
            /*jshint validthis: true */
            d3.select(this).attr('x', d.x = d3.event.x).attr('y', d.y = d3.event.y);
          }

          function dragended(d) {
            /*jshint validthis: true */
            d3.select(this).classed('dragging', false);
          }
              
          var drag = force.drag()
              .origin(function(d) { return d; })
              .on('dragstart', dragstarted)
              .on('drag', dragged)
              .on('dragend', dragended);
      } 
      update();


        function nodeClick(d){
          scope.config.nodeClick(d, 'A');
          scope.$apply();
          d3.event.stopPropagation();
        }

        function nodeDoubleClick(d){
          scope.config.nodeDoubleClick(d);
          svg.remove();
          scope.$apply();
          d3.event.stopPropagation();
        }

        // Broadcast listener
        scope.$on('directedGraphUpdate',function(event, data){
          update();
        });    

      }
    };
  });
