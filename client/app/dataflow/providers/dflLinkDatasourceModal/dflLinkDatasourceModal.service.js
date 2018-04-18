'use strict';

function dflLinkDatasourceModalService($rootScope, $uibModal) {
    // Service logic
    // ...
    function linkDatasourceModalCtrl ($scope, $uibModalInstance, $http, hideDatasources, $filter, $timeout) {
      $scope.datasources = [];
      $scope.loadFinished = false;

			$http({
				method: 'GET',
				url: '/api/dfl-datasources/getAllDatasources',
				params: {opcoId: $scope.entry.OPCO_ID}
			}).then(function (response) {
        // Remove all items from returned list that are passed in hideDatasources array
        if (typeof hideDatasources !== 'undefined' && hideDatasources.length) {
          // for (var i = 0; i < hideDatasources.length; i++) {
          //   response.data = _.reject(response.data, function(item) {return item.DATASOURCE_ID == hideDatasources[i];})
          // }

          _.each(hideDatasources, function(hideDatasource){
            response.data = _.reject(response.data, function(item) {return item.DATASOURCE_ID == hideDatasource; });
          });
        }
				$scope.datasources = response.data;
        $scope.filteredDatasources = $filter('filter') ($scope.datasources, $scope.entry.searchDatasource);
        $scope.loadFinished = true;

        // Pagination in controller
        $scope.pageSize = 10;
        $scope.currentPage = 1;

			}, function (err) {

			});

      $scope.setCurrentPage = function(currentPage) {
          $scope.currentPage = currentPage;
      };

      // Watch filter change
      var timer = false;
      var timeoutFilterChange = function(newValue, oldValue){
           // remove filters with blank values
          $scope.entry.searchDatasource = _.pick($scope.entry.searchDatasource, function(value, key, object) {
            return value !== '' && value !== null;
          });

          if (_.size($scope.entry.searchDatasource) === 0) {
            delete $scope.entry.searchDatasource;
          }  
            
          if(timer){
            $timeout.cancel(timer);
          }
          timer = $timeout(function(){

            $scope.filteredDatasources = $filter('filter') ($scope.datasources, $scope.entry.searchDatasource);
            $scope.currentPage = 1;
          }, 400);
      };
      $scope.$watch('entry.searchDatasource', timeoutFilterChange, true);   

		  $scope.removeAllFilters = function () {
		    delete $scope.entry.searchDatasource;
		  };

		  $scope.removeFilter = function (element) {
		    delete $scope.entry.searchDatasource[element];
		    if (_.size($scope.entry.searchDatasource) === 0) {
		    	delete $scope.entry.searchDatasource;
		    }
		  };

      $scope.modalCancel = function () {
        $uibModalInstance.dismiss('User cancel');
      };

      $scope.selectDatasource = function (datasourceId) {
        $uibModalInstance.close(datasourceId);
      };

    }

    return function(hideDatasources) {
      var instance = $uibModal.open({
        templateUrl: 'app/dataflow/providers/dflLinkDatasourceModal/dflLinkDatasourceModal.html',
        controller: linkDatasourceModalCtrl,
        resolve: {
            hideDatasources : function() {return hideDatasources;}
        },
        size: 'lg',
      });
      return instance.result.then(function(data) {return data;});
    };
  }

angular.module('amxApp')
  .factory('dflLinkDatasourceModal', dflLinkDatasourceModalService);
