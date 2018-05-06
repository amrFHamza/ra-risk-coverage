'use strict';

function CoverageService($rootScope, Entry, $http, $q, $uibModal, $timeout) {

  // Public API here
    return {
      // *****
      // *****
      // Pickers
      // *****  
      pickProductGroup: (function() {

          function pickProductGroupCtrl($scope, $uibModalInstance, init) {

            $scope.entry = Entry;
            $scope.selected = [];
            $scope.productGroups = [];

            $http({
              url: '/api/coverage/getProductGroups', 
              method: 'GET',
              params: {}
            }).then(function (response) {
              $scope.productGroups = response.data;
              // filter existing items provided in init variable 
              _.each(init, function(init) {
                $scope.productGroups = _.reject($scope.productGroups, function(pg) {
                  return pg.PRODUCT_GROUP_ID == init.PRODUCT_GROUP_ID;
                });
              });
            }, function (err) {
              console.log(err);
            });  

            $scope.selectAll = function() {
              $scope.productGroups.forEach(function(m) {m.SELECTED = 'Y'; });
              $scope.clickProductGroupCheckbox();
            };

            $scope.clickProductGroupCheckbox = function() {
              $scope.selected = _.filter($scope.productGroups, function(elem) { return elem.SELECTED == 'Y';});
            };

            $scope.cancel = function() {
              $uibModalInstance.dismiss('cancel');
            };

            $scope.save = function() {  
              $uibModalInstance.close($scope.selected);
            };

            $scope.getColor = function(str) {
              var colorHash = new window.ColorHash();
              return colorHash.hex(str + 10);
            };
          }


          return function(init) {
            var instance = $uibModal.open({
              templateUrl: 'app/coverage/providers/Coverage/pick-product-group-modal.html',
              controller: pickProductGroupCtrl,
              size: 'md',
              resolve: {
                  init : function() {return init;}
              },             
            });
            return instance.result.then(function(data){
              data.forEach(function(m) {m.SELECTED = 'N';});
              return data;
            });
          };

      })(),      



      // *****
      // *****
      // Risk Catalogue
      // *****      
      getProcesses: function(){
        return $http({
          url: '/api/coverage/getProcesses',
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getSubProcesses: function(){
        return $http({
          url: '/api/coverage/getSubProcesses', 
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getRisks: function(){
        return $http({
          url: '/api/coverage/getRisks', 
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      postRisk: function(data){
        return $http({
          url: '/api/coverage/postRisk', 
          method: 'POST',
          data: data
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      }, 
      getRiskInfo: function(riskId){
        return $http({
          url: '/api/coverage/getRiskInfo', 
          method: 'GET',
          params: {riskId: riskId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getSubRisks: function(riskId){
        return $http({
          url: '/api/coverage/getSubRisks', 
          method: 'GET',
          params: {riskId: riskId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getMeasuresForRiskId: function(riskId){
        return $http({
          url: '/api/coverage/getMeasuresForRiskId', 
          method: 'GET',
          params: {riskId: riskId}
        }).then(function(response) {
            return response.data;
        }, function (err) {
            return $q.reject(err.data);
        });  
      },
      getAllSubRisks: function(){
        return $http({
          url: '/api/coverage/getAllSubRisks', 
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteRisk: function(riskId){
        return $http({
          url: '/api/coverage/deleteRisk', 
          method: 'DELETE',
          params: {riskId: riskId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },      
      deleteSubRisk: function(subRiskId){
        return $http({
          url: '/api/coverage/deleteSubRisk', 
          method: 'DELETE',
          params: {subRiskId: subRiskId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteSubRiskMeasureLink: function(subRiskId, measureId){
        return $http({
          url: '/api/coverage/deleteSubRiskMeasureLink', 
          method: 'DELETE',
          params: {subRiskId: subRiskId, measureId: measureId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteRiskMeasureLink: function(riskId, measureId){
        return $http({
          url: '/api/coverage/deleteRiskMeasureLink', 
          method: 'DELETE',
          params: {riskId: riskId, measureId: measureId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      linkMeasureToRisk: (function () {

          function linkMeasureToRiskCtrl($scope, $uibModalInstance, init) {

            $scope.entry = Entry;
            $scope.measures = [];
            $scope.risk = {};
            $scope.selectedMeasures = [];
            
            // Get riskInfo
            $http({
              url: '/api/coverage/getRiskInfo', 
              method: 'GET',
              params: {riskId: init.RISK_ID}
            }).then(function (response) {
              $scope.risk = response.data;
            }, function (err) {
              console.log(err);
            });    

            // Get unlinked measures
            $http({
              url: '/api/coverage/getUnlinkedMeasuresForRiskId', 
              method: 'GET',
              params: {riskId: init.RISK_ID}
            }).then(function(response) {
              $scope.measures = response.data;
            }, function (err) {
              console.log(err);
            });

            $scope.selectAll = function() {
              $scope.measures.forEach(function(m) {m.SELECTED = 'Y'; });
              $scope.updateSelected();
            };

            $scope.updateSelected = function() {
              $scope.selectedMeasures = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});
            };

            $scope.cancel = function() {
              $uibModalInstance.dismiss('cancel');
            };

            $scope.submit = function() {

              $scope.selectedMeasures = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});

              $http({
                url: '/api/coverage/postRiskMeasureLink', 
                method: 'POST',
                data: $scope.selectedMeasures,
                params: {riskId: init.RISK_ID}
              })
              .then(function(response) {
                if (response.data.success) {
                  Entry.showToast($scope.selectedMeasures.length + ' measures linked to risk. All changes saved!');
                  $uibModalInstance.close($scope.selectedMeasures);
                }
                else {
                  Entry.showToast('Error ' + response.data.error.code);
                }                
              }, function(response) {
                  return $q.reject(response.data);
              });

            };


          }

          return function(init) {
            var instance = $uibModal.open({
              templateUrl: 'app/coverage/providers/Coverage/link-measures-to-risk-modal.html',
              controller: linkMeasureToRiskCtrl,
              size: 'lg',
              resolve: {
                  init : function() {return init;}
              },             
            });
            return instance.result.then(function (data){return data;});
          };

      })(),

      linkMeasureToSubRisk: (function () {

          function linkMeasureToSubRiskCtrl($scope, $uibModalInstance, init) {

            $scope.entry = Entry;
            $scope.measures = [];
            $scope.selectedMeasures = [];

            // Pagination
            $scope.pageSize = 20;
            $scope.currentPage = 1;

            $scope.setCurrentPage = function(currentPage) {
                $scope.currentPage = currentPage;
            };
    
            // Get unlinked measures
            $http({
              url: '/api/coverage/getUnlinkedMeasuresForSubRiskId', 
              method: 'GET',
              params: {subRiskId: init.SUB_RISK_ID}
            }).then(function(response) {
              $scope.measures = response.data;
            }, function (err) {
              console.log(err);
            });

            $scope.selectAll = function() {
              $scope.measures.forEach(function(m) {m.SELECTED = 'Y'; });
              $scope.updateSelected();
            };

            $scope.updateSelected = function() {
              $scope.selectedMeasures = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});
            };

            $scope.cancel = function() {
              $uibModalInstance.dismiss('cancel');
            };

            $scope.submit = function() {

              $scope.selectedMeasures = _.filter($scope.measures, function(elem) { return elem.SELECTED == 'Y';});

              $http({
                url: '/api/coverage/postSubRiskMeasureLink', 
                method: 'POST',
                data: $scope.selectedMeasures,
                params: {subRiskId: init.SUB_RISK_ID}
              })
              .then(function(response) {
                if (response.data.success) {
                  Entry.showToast($scope.selectedMeasures.length + ' measures linked to selected sub-risk. All changes saved!');
                  $uibModalInstance.close($scope.selectedMeasures);
                }
                else {
                  Entry.showToast('Error ' + response.data.error.code);
                }                
              }, function(response) {
                  return $q.reject(response.data);
              });

            };


          }

          return function(init) {
            var instance = $uibModal.open({
              templateUrl: 'app/coverage/providers/Coverage/link-measures-to-risk-modal.html',
              controller: linkMeasureToSubRiskCtrl,
              size: 'lg',
              resolve: {
                  init : function() {return init;}
              },             
            });
            return instance.result.then(function (data){return data;});
          };

      })(),
      // *****
      // *****
      // Key Risk Areas
      // *****        
      getKeyRiskAreas: function(){
        return $http({
          url: '/api/coverage/getKeyRiskAreas',
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getKeyRiskArea: function(keyRiskAreaId){
        return $http({
          url: '/api/coverage/getKeyRiskArea',
          method: 'GET',
          params: {keyRiskAreaId: keyRiskAreaId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getKeyRiskAreaRisks: function(keyRiskAreaId){
        return $http({
          url: '/api/coverage/getKeyRiskAreaRisks',
          method: 'GET',
          params: {keyRiskAreaId: keyRiskAreaId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getKeyRiskAreaProductGroups: function(keyRiskAreaId){
        return $http({
          url: '/api/coverage/getKeyRiskAreaProductGroups',
          method: 'GET',
          params: {keyRiskAreaId: keyRiskAreaId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      linkKeyRiskAreaProductGroup: function(keyRiskAreaId, keyRiskAreaProductGroups){
        return $http({
          url: '/api/coverage/linkKeyRiskAreaProductGroup',
          method: 'POST',
          data: {keyRiskAreaId: keyRiskAreaId, keyRiskAreaProductGroups: keyRiskAreaProductGroups}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      unlinkKeyRiskAreaProductGroup: function(keyRiskAreaId, keyRiskAreaProductGroups){
        return $http({
          url: '/api/coverage/unlinkKeyRiskAreaProductGroup',
          method: 'POST',
          data: {keyRiskAreaId: keyRiskAreaId, keyRiskAreaProductGroups: keyRiskAreaProductGroups}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },      
      linkKeyRiskAreaRisks: function(keyRiskAreaId, keyRiskAreaRisks){
        return $http({
          url: '/api/coverage/linkKeyRiskAreaRisks',
          method: 'POST',
          data: {keyRiskAreaId: keyRiskAreaId, keyRiskAreaRisks: keyRiskAreaRisks}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      unlinkKeyRiskAreaRisks: function(keyRiskAreaId, keyRiskAreaRisks){
        return $http({
          url: '/api/coverage/unlinkKeyRiskAreaRisks',
          method: 'POST',
          data: {keyRiskAreaId: keyRiskAreaId, keyRiskAreaRisks: keyRiskAreaRisks}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      postKeyRiskArea: function(keyRiskArea){
        return $http({
          url: '/api/coverage/postKeyRiskArea',
          method: 'POST',
          data: {keyRiskArea: keyRiskArea}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteKeyRiskArea: function(keyRiskAreaId){
        return $http({
          url: '/api/coverage/deleteKeyRiskArea',
          method: 'DELETE',
          params: {keyRiskAreaId: keyRiskAreaId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getKeyRiskAreaLandscape: function(opcoId){
        return $http({
          url: '/api/coverage/getKeyRiskAreaLandscape',
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getKeyRiskAreaLandscapeSums: function(opcoId){
        return $http({
          url: '/api/coverage/getKeyRiskAreaLandscapeSums',
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },

      // *****
      // *****
      // *****
      // *****
      // Coverage
      // *****
      linkSystemToRiskNode: (function (inRiskNode) {

          function linkSystemToRiskNodeCtrl($scope, $uibModalInstance, init) {

            $scope.entry = Entry;
            $scope.systems = [];
            $scope.chunkedSystems = [];

            // Get riskInfo
            $http({
              url: '/api/coverage/getSystems', 
              method: 'GET',
              params: {opcoId: (init[0].OPCO_ID?init[0].OPCO_ID:$scope.entry.currentUser.userOpcoId), riskId: (init[0].RISK_ID?init[0].RISK_ID:0), productSegmentId: (init[0].PRODUCT_SEGMENT_ID?init[0].PRODUCT_SEGMENT_ID:0)}
            }).then(function (response) {
              $scope.systems = response.data;
              $scope.chunkedSystems = chunk($scope.systems, 2);
            }, function (err) {
              console.log(err);
            });  

            function chunk(arr, pieces) {
              var size = Math.ceil(arr.length / pieces);
              var newArr = [];
              for (var i=0; i<arr.length; i+=size) {
                newArr.push(arr.slice(i, i+size));
              }
              return newArr;
            }

            $scope.cancel = function() {
              $uibModalInstance.dismiss('cancel');
            };

            $scope.selectSystem = function(systemId, systemName) {
              var returnRiskNodes = [];
              for (var i=0; i<init.length; i++) {
                  var newNode = angular.copy(init[i]);
                  newNode.SYSTEM_ID = systemId;
                  newNode.SYSTEM_NAME = systemName;
                  returnRiskNodes.push(newNode);                  
              }

              // Post risk nodes
              $http({
                url: '/api/coverage/postRiskNodes', 
                method: 'POST',
                data: returnRiskNodes
              })
              .then(function(response) {
                if (response.data.success && !response.data.refreshPage) {
                  Entry.showToast('System "' + response.data.RISK_NODES[0].SYSTEM_NAME + '" linked to risk node. All changes saved!');
                  // RISK_NODES is returned from the API
                  $uibModalInstance.close(response.data);
                }
                else if (response.data.success && response.data.refreshPage) {
                  Entry.showToast('Risk node with same system already exists. Some nodes were left unchanged.');
                  // RISK_NODES is returned from the API
                  $uibModalInstance.close(response.data);                  
                }
                else {
                  Entry.showToast('Error ' + response.data.error.code);
                }                
              }, function(response) {
                  return $q.reject(response.data);
              });
            };
          }

          return function(init) {
            var instance = $uibModal.open({
              templateUrl: 'app/coverage/providers/Coverage/link-system-to-risk-node-modal.html',
              controller: linkSystemToRiskNodeCtrl,
              size: 'md',
              resolve: {
                  init : function() {return init;}
              },             
            });
            return instance.result.then(function(data){
              return data;
            });
          };

      })(),
      showProductSegmentSankeyDiagram: (function () {

        var showSankeyDiagramCtrl = function($scope, $uibModalInstance, productSegment) {
          
          $scope.entry = Entry;
          $scope.productSegment = productSegment;

          $scope.sankeyDiagramConfig = {};
          $scope.sankeyDiagramConfig.links = [];

          $http({
            url: '/api/coverage/getSankeyProductSegment', 
            method: 'GET',
            params: {productSegmentId: productSegment.PRODUCT_SEGMENT_ID}
          })
          .then(function(response) {
            $scope.sankeyDiagramConfig.links = _.filter(response.data, function(e) { return e.value > 0; });
            $scope.sankeyDiagramConfig.units = 'RPN';
            // Broadcast for update
            $scope.$broadcast('sankeyDiagramUpdate',{});
          }, function(response) {
            return $q.reject(response.data);
          });

          $scope.cancel = function() {
            $uibModalInstance.dismiss('cancel');
          };

        };

        return function(productSegment) {
          var instance = $uibModal.open({
            templateUrl: 'app/coverage/routes/riskNodeTable/product-segment-sankey-modal.html',
            controller: showSankeyDiagramCtrl,
            windowClass: 'app-sankey-modal',
            resolve: {'productSegment' : function() { return productSegment; }}       
          });
          return instance.result.then(function (data){return data;});
        };

      })(),      
      getProductSegments: function(opcoId){
        return $http({
          url: '/api/coverage/getProductSegments', 
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getProductSegment: function(productSegmentId){
        return $http({
          url: '/api/coverage/getProductSegment', 
          method: 'GET',
          params: {productSegmentId: productSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getProductSegmentSubRisks: function(productSegmentId){
        return $http({
          url: '/api/coverage/getProductSegmentSubRisks', 
          method: 'GET',
          params: {productSegmentId: productSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getSankeyProductSegment: function(productSegmentId){
        return $http({
          url: '/api/coverage/getSankeyProductSegment', 
          method: 'GET',
          params: {productSegmentId: productSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getSankeyOverview: function(opcoId){
        return $http({
          url: '/api/coverage/getSankeyOverview', 
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getControls: function(opcoId, systemId){
        return $http({
          url: '/api/coverage/getControls', 
          method: 'GET',
          params: {opcoId: opcoId, systemId: systemId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getRiskNodeControls: function(riskNodeId){
        return $http({
          url: '/api/coverage/getRiskNodeControls', 
          method: 'GET',
          params: {riskNodeId: riskNodeId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getControlDetails: function(controlId){
        return $http({
          url: '/api/coverage/getControlDetails', 
          method: 'GET',
          params: {controlId: controlId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getCloneOtherProductSegment: function(opcoId, productSegmentId){
        return $http({
          url: '/api/coverage/getCloneOtherProductSegment', 
          method: 'GET',
          params: {opcoId: opcoId, productSegmentId: productSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getExecuteCloneOtherProductSegment: function(cloneFromProductSegmentId, cloneToProductSegmentId){
        return $http({
          url: '/api/coverage/getExecuteCloneOtherProductSegment', 
          method: 'GET',
          params: {cloneFromProductSegmentId: cloneFromProductSegmentId, cloneToProductSegmentId: cloneToProductSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getExecuteCloneRiskNodeToProductSegment: function(cloneFromRiskNodeId, cloneToProductSegmentId){
        return $http({
          url: '/api/coverage/getExecuteCloneRiskNodeToProductSegment', 
          method: 'GET',
          params: {cloneFromRiskNodeId: cloneFromRiskNodeId, cloneToProductSegmentId: cloneToProductSegmentId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getCloneControlsRiskNodes: function(riskNodeId){
        return $http({
          url: '/api/coverage/getCloneControlsRiskNodes', 
          method: 'GET',
          params: {riskNodeId: riskNodeId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getExecuteCloneControlsRiskNodes: function(riskNodeIdFrom, riskNodeIdTo){
        return $http({
          url: '/api/coverage/getExecuteCloneControlsRiskNodes', 
          method: 'GET',
          params: {riskNodeIdFrom: riskNodeIdFrom, riskNodeIdTo: riskNodeIdTo}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getHeatMapData: function(opcoId){
        return $http({
          url: '/api/coverage/getHeatMapData', 
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            // Filter out records having bad RPN values
            return _.reject(response.data, function(e) {return isNaN(Number(e.RPN_VALUE)) || Number(e.RPN_VALUE) === 0;});
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      postRiskNodes: function(riskNodes){
        return $http({
          url: '/api/coverage/postRiskNodes', 
          method: 'POST',
          data: riskNodes
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteRiskNodes: function(riskNodes){
        return $http({
          url: '/api/coverage/deleteRiskNodes', 
          method: 'POST',
          data: riskNodes
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      deleteProductSegments: function(productSegments){
        return $http({
          url: '/api/coverage/deleteProductSegments', 
          method: 'POST',
          data: productSegments
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getRiskNodes: function(data){
        return $http({
          url: '/api/coverage/getRiskNodes', 
          method: 'POST',
          data: data
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      postRiskNode: function(data){
        return $http({
          url: '/api/coverage/postRiskNode', 
          method: 'POST',
          data: data
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      unlinkSubRisk: function(rnSubRiskId){
        return $http({
          url: '/api/coverage/unlinkSubRisk', 
          method: 'DELETE',
          params: {rnSubRiskId: rnSubRiskId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      saveRiskNodeComment: function(data){
        return $http({
          url: '/api/coverage/saveRiskNodeComment', 
          method: 'POST',
          data: data
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },   
      unlinkControl: function(rnControlId){
        return $http({
          url: '/api/coverage/unlinkControl', 
          method: 'DELETE',
          params: {rnControlId: rnControlId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },
      getRiskNodeDetails: function(riskNode){
        $http({
          url: '/api/coverage/getRiskNodeDetails', 
          method: 'POST',
          data: riskNode
        })
        .then(function(response) {
            riskNode.SUB_RISKS = response.data.SUB_RISKS;
            riskNode.MEASURES = response.data.MEASURES;
            riskNode.CONTROLS = response.data.CONTROLS;
            riskNode.CTRL_SUB_RISKS = response.data.CTRL_SUB_RISKS;
            riskNode.CTRL_MEASURES = response.data.CTRL_MEASURES;

            // Update RiskNode level numbers
            riskNode.SUB_RISK_COUNT = response.data.RISK_NODE.SUB_RISK_COUNT;
            riskNode.RPN_COUNT = response.data.RISK_NODE.RPN_COUNT;
            riskNode.CONTROL_COUNT = response.data.RISK_NODE.CONTROL_COUNT;
            riskNode.COVERAGE = response.data.RISK_NODE.COVERAGE;

          }, function(response) {
            Entry.showToast('Error ' + response.data.error.code);
          });
      },
      newProductSegment: function(productSegment){
        return $http({
          url: '/api/coverage/newProductSegment', 
          method: 'POST',
          data: productSegment
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },  
      editProductSegment: function(productSegment){
        return $http({
          url: '/api/coverage/editProductSegment', 
          method: 'POST',
          data: productSegment
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },      
      getMeasures: function(){
        return $http({
          url: '/api/coverage/getMeasures', 
          method: 'GET',
          params: {}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },      
      getMeasureInfo: function(measureId){
        return $http({
          url: '/api/coverage/getMeasureInfo', 
          method: 'GET',
          params: {measureId: measureId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },  
      postMeasure: function(measure){
        return $http({
          url: '/api/coverage/postMeasure', 
          method: 'POST',
          data: measure
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      }, 
      deleteMeasure: function(measureId){
        return $http({
          url: '/api/coverage/deleteMeasure', 
          method: 'DELETE',
          params: {measureId: measureId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      },           
    }; //END return
}


angular.module('amxApp')
  .factory('Coverage', CoverageService);
