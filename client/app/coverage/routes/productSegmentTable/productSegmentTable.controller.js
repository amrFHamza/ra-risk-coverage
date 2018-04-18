'use strict';

(function(){

class ProductSegmentTableComponent {
constructor($scope, Entry, Coverage, $filter, $timeout, $state, $stateParams, ConfirmModal, $uibModal) {
    $scope.entry = Entry;
    $scope.businessProcesses = [];
    $scope.lobs = [];
    $scope.productSegments = [];
    $scope.selectedProductSegments = [];
    $scope.filteredProductSegments = [];
    $scope.groupFilteredProductSegments = [];
    $scope.productGroups = [];
    $scope.loadFinished = false;
    $scope.isDisabled = $scope.entry.isDisabled();
    $scope._und = _;

    if ($stateParams.opcoId === undefined) {
      $state.go('productSegmentTable', {opcoId: $scope.entry.OPCO_ID}, {reload: true});
    }
    
    var loadData = function(){
      Coverage.getProductSegments($stateParams.opcoId)
        .then(function(data){
          $scope.productSegments = data;
          //$scope.productSegments.forEach(function(e){e.COVERAGE = Math.floor(Math.random() * 100 + 1);})

          $scope.lobs = _.map(_.groupBy(data, 'LOB'), function(g) {
            return { 
                LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
                LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
                PS_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
                PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
                RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
                COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_LOB_VALUE_RATIO/100; }, 0),
                MEASURE_COVERAGE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
              };
          });

          var total = _.map(_.groupBy(data, 'OPCO_ID'), function(g) {
            return { 
                LOB: _.reduce(g, function(m,x) { return 0; }, 0),
                LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
                PS_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
                PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
                RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
                COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_TOTAL_VALUE_RATIO/100; }, 0),
                MEASURE_COVERAGE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
              };
          });
          $scope.lobs.push(total[0]);

          $scope.productGroups = _.map(_.groupBy(data, 'PRODUCT_GROUP_ID'), function(g) {
            return { 
                LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
                PRODUCT_GROUP: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP; }, 0),
                PRODUCT_GROUP_ID: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP_ID; }, 0),
                LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
                PS_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
                PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
                RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
                COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_GROUP_VALUE_RATIO/100; }, 0),
                MEASURE_COVERAGE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
              };
          });

          if (_.size($scope.entry.searchProductSegment) > 0) {
            $scope.filteredProductSegments = $filter('filter') ($scope.productSegments, $scope.entry.searchProductSegment);
            $scope.groupFilteredProductSegments = _.groupBy($scope.filteredProductSegments, 'PRODUCT_GROUP_ID');          
          }
          else {
            $scope.filteredProductSegments = $scope.productSegments;
            $scope.groupFilteredProductSegments = _.groupBy($scope.filteredProductSegments, 'PRODUCT_GROUP_ID');          
          }

      });
    };
    loadData();

    $scope.removeAllFilters = function () {
      $scope.entry.searchProductSegment = {};
    };

    $scope.removeFilter = function (element) {
      delete $scope.entry.searchProductSegment[element];
      if (_.size($scope.entry.searchProductSegment) === 0) {
        $scope.entry.searchProductSegment = {};
      }
    };

    $scope.setFilterLob = function (lob) {
      if (lob) {
        delete $scope.entry.searchProductSegment.PRODUCT_GROUP_ID;        
        $scope.entry.searchProductSegment.LOB = lob;
      }
      else {
        delete $scope.entry.searchProductSegment.PRODUCT_GROUP_ID;        
        delete $scope.entry.searchProductSegment.LOB;
      }
    };

    $scope.setFilterProductGroup = function (productGroupId) {
      if (productGroupId) {
        $scope.entry.searchProductSegment.PRODUCT_GROUP_ID = productGroupId;
      }
      else {
        delete $scope.entry.searchProductSegment.PRODUCT_GROUP_ID;
      }
    };

    $scope.selectAll = function() {
      $scope.filteredRiskNodes.forEach(function(m) {m.SELECTED='Y';});
      $scope.updateSelected();
    };

    $scope.unselectAll = function() {
      $scope.filteredRiskNodes.forEach(function(m) {m.SELECTED='N';});
      $scope.updateSelected();
    };

    $scope.updateSelected = function() {
      $scope.selectedProductSegments = _.filter($scope.productSegments, function(elem) { return elem.SELECTED == 'Y';});
    };

    $scope.deleteProductSegments = function(productSegments) {
      ConfirmModal('Are you sure you want to delete selected product segments? All related risk nodes will be deleted also.')
      .then(function(confirmResult) {
        if (confirmResult) {

          Coverage.deleteProductSegments(productSegments).then(function(response){
            if (response.success) { 
              loadData();
              Entry.showToast('Risk nodes deleted. All changes saved!');
            }
            else {
              Entry.showToast('Delete action failed. Error ' + response.err);
            }           
          });

        }
      })
      .catch(function(err) {
            Entry.showToast('Delete action canceled');
      });
    };

    $scope.compareProductSegments = function(productSegments) {
      $state.go('productSegmentCompare', {productSegmentIdA: productSegments[0].PRODUCT_SEGMENT_ID, productSegmentIdB: productSegments[1].PRODUCT_SEGMENT_ID});
    };

    $scope.riskNodeTable = function(productSegmentId) {
      if (productSegmentId) {
        $state.go('riskNodeTable', {productSegmentId: productSegmentId}, {reload: true});
      }
      else {
        $state.go('productSegmentTable', {}, {reload: true});
      }
    };

    $scope.newProductSegment = function(opcoId, productGroupId) {
      var newProductSegmentCtrl = function($scope, $uibModalInstance, opcoId) {
        
        $scope.entry = Entry;
        $scope.productGroups = [];
        $scope.productSegment = {
                                  OPCO_ID: opcoId,
                                  OPTIONS: 'Full'
                                };

        if (productGroupId) {
          $scope.productSegment.PRODUCT_GROUP_ID = productGroupId;
        }

        Coverage.getProductSegments($stateParams.opcoId).then(function(data){
          //$scope.productSegments = data;
          $scope.productGroups = _.map(_.groupBy(data, 'PRODUCT_GROUP_ID'), function(g) {
            return { 
                LOB: _.reduce(g, function(m,x) { return x.LOB; }, 0),
                PRODUCT_GROUP: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP; }, 0),
                PRODUCT_GROUP_ID: _.reduce(g, function(m,x) { return x.PRODUCT_GROUP_ID; }, 0),
                LOB_COUNT: _.reduce(g, function(m,x) { return m + 1; }, 0),
                PS_VALUE: _.reduce(g, function(m,x) { return m + Math.abs(x.PS_VALUE); }, 0),
                PS_TOTAL_VALUE_RATIO: _.reduce(g, function(m,x) { return m + x.PS_TOTAL_VALUE_RATIO; }, 0),
                RISK_COUNT: _.reduce(g, function(m,x) { return m + x.RISK_COUNT; }, 0),
                COVERAGE: _.reduce(g, function(m,x) { return m + x.COVERAGE * x.PS_GROUP_VALUE_RATIO/100; }, 0),
                MEASURE_COVERAGE: _.reduce(g, function(m,x) { return m + x.MEASURE_COVERAGE; }, 0),
              };
          });          
        });

        $scope.cancel = function() {
          $uibModalInstance.dismiss('cancel');
        };

        $scope.save = function() {
          if (!$scope.datoForm.$valid) {
            Entry.showToast('Please enter all required fields!');
          }
          else {          
            $uibModalInstance.close($scope.productSegment);
          }
        };

      };

      var instance = $uibModal.open({
        templateUrl: 'app/coverage/routes/productSegmentTable/new-product-segment-modal.html',
        controller: newProductSegmentCtrl,
        size: 'lg',
        resolve: {'opcoId' : function() { return opcoId; }}
      });

      instance.result.then(function(data){
        Coverage.newProductSegment(data).then(function(response){
          if (response.success) {
            Entry.showToast('Product segment created. All changes saved!');
            $state.go('riskNodeTable', {productSegmentId: response.productSegmentId}, {reload: true});            
          }
          else {
            Entry.showToast('Action failed. Error ' + response.err);
          }     
        });
      });      
    };

    $scope.showSankeyDiagram = function(productSegment) {
      Coverage.showProductSegmentSankeyDiagram(productSegment);
    };
    
    // Reload OPCO_ID change
    $scope.$watch('entry.OPCO_ID', function(){
      setTimeout (function () {
        
        if ($scope.entry.searchProductSegment) {
          delete $scope.entry.searchProductSegment.PRODUCT_GROUP_ID;
        }

        $state.go('productSegmentTable', {opcoId: $scope.entry.OPCO_ID} );
      }, 300); 
    });     

    // Watch filter change
    var timeoutFilterChange = function(){
      
        $timeout(function(){
          $scope.loadFinished = false;

          // remove filters with blank values
          $scope.entry.searchProductSegment = _.pick($scope.entry.searchProductSegment, function(value, key, object) {
            return value !== '' && value !== null;
          });
          
          if (_.size($scope.entry.searchProductSegment) === 0) {
            //delete $scope.entry.searchProductSegment;
            $scope.entry.searchProductSegment = {};
          }

          if (_.size($scope.entry.searchProductSegment) > 0) {
            $scope.filteredProductSegments = $filter('filter') ($scope.productSegments, $scope.entry.searchProductSegment);
          }
          else {
            $scope.filteredProductSegments = $scope.productSegments;
          }

          $scope.groupFilteredProductSegments = _.groupBy($scope.filteredProductSegments, 'PRODUCT_GROUP_ID');
          $scope.loadFinished = true;
        }, 400);
    };
    $scope.$watch('entry.searchProductSegment', timeoutFilterChange, true);     

  }
}

angular.module('amxApp')
  .component('productSegmentTable', {
    templateUrl: 'app/coverage/routes/productSegmentTable/productSegmentTable.html',
    controller: ProductSegmentTableComponent,
    controllerAs: 'productSegmentTableCtrl'
  });

})();
