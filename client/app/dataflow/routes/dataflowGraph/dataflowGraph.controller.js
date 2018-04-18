'use strict';

(function(){

class DataflowGraphComponent {
  constructor($scope, Entry, $timeout, $state, $stateParams, $http) {
    $scope.entry = Entry;
    $scope.directedGraphConfig = {};
    $scope.directedGraphConfig.links = [];
    $scope.directedGraphConfig.linksBackup = [];

    $scope.infoElement = {};
    $scope.selectedElement = {};

    // Callback functions 
    function nodeClick(d, getDirection) {

      $scope.directedGraphConfig.infoElement = d.objectTag;
      $scope.directedGraphConfig.selectedElement = d.objectTag;
      $scope.addNode(d.objectId, d.objectClass, getDirection);

      $http({
        method: 'GET',
        url: (d.objectClass === 'P'?'/api/dfl-procedures/getProcedure':'/api/dfl-datasources/getDatasource'),
        params: {procedureId: (d.objectClass === 'P'?d.objectId:null), datasourceId: (d.objectClass === 'D'?d.objectId:null)}
      }).then(function (response) {  
        $scope.infoElement = response.data;
        $scope.infoElement.objectClass = d.objectClass;
        $scope.infoElement.objectId = d.objectId;
      }, function (err) {
            console.log(err);
      });
    }

    function nodeDoubleClick(d) {
        if (d.objectClass === 'D') {
          if(d.type === 'R') {
            var queryParamsArray = d.objectId.split('-');
            var metricId = queryParamsArray[1];
            var opcoId = queryParamsArray[2]; 
            $state.go('metricInfo', {opcoId: opcoId, metricId: metricId}, {reload: true});
          }
          else {
            $state.go('datasourceInfo', {datasourceId: d.objectId}, {reload: true});
          }
        }
        else {
            $state.go('procedureInfo', {procedureId: d.objectId}, {reload: true});
        }
    }
    
    $scope.directedGraphConfig.nodeClick = nodeClick;
    $scope.directedGraphConfig.nodeDoubleClick = nodeDoubleClick;

    $scope.restoreLinks = function() {
      $scope.directedGraphConfig.links = angular.copy($scope.directedGraphConfig.linksBackup.pop());      
      // Broadcast for update
      $scope.$broadcast('directedGraphUpdate',{});      
    };

    $scope.addNode = function(nodeId, nodeClass, getDirection) {

      var linksBackup = angular.copy($scope.directedGraphConfig.links);

      var findLink = function(linksArray, tagSource, tagTarget) {
        return _.find(linksArray, 
          function(element) { return (element.source.objectTag === tagSource) && (element.target.objectTag === tagTarget); 
        });
      };

      if (nodeClass === 'P') {
          // Get procedure info
          $http({
            method: 'GET',
            url: '/api/dfl-procedures/getProcedure',
            params: {procedureId: nodeId}
          }).then(function (response) {      

              // **START: Get linked datasources
              var procedure = response.data;
              var datasources = [];

              $http({
                method: 'GET',
                url: '/api/dfl-procedures/getLinkedDatasources',
                params: {procedureId: nodeId, getDirection: getDirection}
              }).then(function (response) {

                datasources = response.data;

                for (var i=0; i<datasources.length; i++) {
                  if (datasources[i].DIRECTION === 'I') {
                    // if (typeof _.find($scope.directedGraphConfig.links, function(element) { return (element.source.objectTag === ('D' + datasources[i].DATASOURCE_ID)) && (element.target.objectTag === ('P' + procedure.PROCEDURE_ID)); }) === 'undefined') {                
                    if (typeof findLink($scope.directedGraphConfig.links, 'D' + datasources[i].DATASOURCE_ID, 'P' + procedure.PROCEDURE_ID) === 'undefined') {                
                      $scope.directedGraphConfig.links.push({
                        source: {
                                  name: datasources[i].NAME, 
                                  type: datasources[i].TYPE, 
                                  objectClass: 'D', 
                                  objectId: datasources[i].DATASOURCE_ID,
                                  objectTag: 'D' + datasources[i].DATASOURCE_ID
                                },
                        target: {
                                  name: procedure.NAME, 
                                  type: procedure.TYPE, 
                                  objectClass: 'P', 
                                  objectId: procedure.PROCEDURE_ID,
                                  objectTag: 'P' + procedure.PROCEDURE_ID
                                }
                      });
                    }
                  }
                  else if (datasources[i].DIRECTION === 'O') {
                    // if (typeof _.find($scope.directedGraphConfig.links, function(element) { return (element.source.objectTag === ('P' + procedure.PROCEDURE_ID)) && (element.target.objectTag === ('D' + datasources[i].DATASOURCE_ID)); }) === 'undefined') {                
                    if (typeof findLink($scope.directedGraphConfig.links, 'P' + procedure.PROCEDURE_ID, 'D' + datasources[i].DATASOURCE_ID) === 'undefined') {                
                      $scope.directedGraphConfig.links.push({
                        source: {
                                  name: procedure.NAME, 
                                  type: procedure.TYPE, 
                                  objectClass: 'P', 
                                  objectId: procedure.PROCEDURE_ID,
                                  objectTag: 'P' + procedure.PROCEDURE_ID
                                },
                        target: {
                                  name: datasources[i].NAME, 
                                  type: datasources[i].TYPE, 
                                  objectClass: 'D', 
                                  objectId: datasources[i].DATASOURCE_ID,
                                  objectTag: 'D' + datasources[i].DATASOURCE_ID
                                }
                      });
                    }
                  }
                }
                // Broadcast for update
                $scope.$broadcast('directedGraphUpdate',{});
                
                // Do backup if new links added
                if (!linksBackup.length || $scope.directedGraphConfig.links.length !== linksBackup.length) {
                  $scope.directedGraphConfig.linksBackup.push(linksBackup);
                }

              }, function (err) {
                console.log(err);
              });
              // **END: Get linked datasources

          }, function (err) {
            // handle error
            console.log(err);
          });   
      }
      else if (nodeClass === 'D') {
          // Get procedure info
          $http({
            method: 'GET',
            url: '/api/dfl-datasources/getDatasource',
            params: {datasourceId: nodeId}
          }).then(function (response) {      

              // **START: Get linked datasources
              var datasource = response.data;
              var procedures = [];

              $http({
                method: 'GET',
                url: '/api/dfl-datasources/getLinkedProcedures',
                params: {datasourceId: nodeId, getDirection: getDirection}
              }).then(function (response) {

                procedures = response.data;

                for (var i=0; i<procedures.length; i++) {
                  if (procedures[i].DIRECTION === 'O') {
                    // if (typeof _.find($scope.directedGraphConfig.links, function(element) { return (element.source.objectTag === ('P' + procedures[i].PROCEDURE_ID)) && (element.target.objectTag === ('D' + datasource.DATASOURCE_ID)); }) === 'undefined') {                
                    if (typeof findLink($scope.directedGraphConfig.links, 'P' + procedures[i].PROCEDURE_ID, 'D' + datasource.DATASOURCE_ID) === 'undefined') {                
                      $scope.directedGraphConfig.links.push({
                        source: {
                                  name: procedures[i].NAME, 
                                  type: procedures[i].TYPE, 
                                  objectClass: 'P', 
                                  objectId: procedures[i].PROCEDURE_ID,
                                  objectTag: 'P' + procedures[i].PROCEDURE_ID
                                },
                        target: {
                                  name: datasource.NAME, 
                                  type: datasource.TYPE, 
                                  objectClass: 'D', 
                                  objectId: datasource.DATASOURCE_ID,
                                  objectTag: 'D' + datasource.DATASOURCE_ID
                                }
                      });
                    }
                  }
                  else if (procedures[i].DIRECTION === 'I') {
                    // if (typeof _.find($scope.directedGraphConfig.links, function(element) { return (element.source.objectTag === ('D' + datasource.DATASOURCE_ID)) && (element.target.objectTag === ('P' + procedures[i].PROCEDURE_ID)); }) === 'undefined') {                
                    if (typeof findLink($scope.directedGraphConfig.links, 'D' + datasource.DATASOURCE_ID, 'P' + procedures[i].PROCEDURE_ID) === 'undefined') {
                      $scope.directedGraphConfig.links.push({
                        source: {
                                  name: datasource.NAME, 
                                  type: datasource.TYPE, 
                                  objectClass: 'D', 
                                  objectId: datasource.DATASOURCE_ID,
                                  objectTag: 'D' + datasource.DATASOURCE_ID
                                },
                        target: {
                                  name: procedures[i].NAME, 
                                  type: procedures[i].TYPE, 
                                  objectClass: 'P', 
                                  objectId: procedures[i].PROCEDURE_ID,
                                  objectTag: 'P' + procedures[i].PROCEDURE_ID
                                }
                      });
                    }
                  }
                }
                // Broadcast for update
                $scope.$broadcast('directedGraphUpdate',{});

                // Do backup if new links added
                if (!linksBackup.length || $scope.directedGraphConfig.links.length !== linksBackup.length) {
                  $scope.directedGraphConfig.linksBackup.push(linksBackup);
                }

              }, function (err) {
                console.log(err);
              });
              // **END: Get linked datasources

          }, function (err) {
            // handle error
            console.log(err);
          });   
      }

    };

    if (typeof $stateParams.procedureId !== 'undefined') {
      // $scope.directedGraphConfig.selectedElement = 'P' + $stateParams.procedureId;
      // $scope.directedGraphConfig.infoElement = 'P' + $stateParams.procedureId;
      // $scope.addNode($stateParams.procedureId, 'P');
      nodeClick({objectId: $stateParams.procedureId , objectClass: 'P' , objectTag: 'P' + $stateParams.procedureId }, 'A');
    }
    else if (typeof $stateParams.datasourceId !== 'undefined') {
      // $scope.directedGraphConfig.selectedElement = 'D' + $stateParams.datasourceId;
      // $scope.directedGraphConfig.infoElement = 'D' + $stateParams.datasourceId;
      // $scope.addNode($stateParams.datasourceId, 'D');
      nodeClick({objectId: $stateParams.datasourceId , objectClass: 'D' , objectTag: 'D' + $stateParams.datasourceId }, 'A');
    }

    // $scope.directedGraphConfig.state = $scope.entry.state;
    // $scope.directedGraphConfig.stateParams = $scope.entry.stateParams;
  }
}

angular.module('amxApp')
  .component('dataflowGraph', {
    templateUrl: 'app/dataflow/routes/dataflowGraph/dataflowGraph.html',
    controller: DataflowGraphComponent,
    controllerAs: 'dataflowGraphCtrl'
  });

})();