'use strict';

(function(){

class KeyRiskAreaTableComponent {
  constructor($scope, Entry, $http, $state, $stateParams, ConfirmModal, Coverage) {
    $scope.entry = Entry;
    $scope.isDisabled = (Number($scope.entry.currentUser.userOpcoId) !== 0);
    $scope.keyRiskAreas = [];
    $scope.loadFinished = false; 

		Coverage.getKeyRiskAreas().then(function (response) {
			$scope.keyRiskAreas = response;
			$scope.loadFinished = true;
		}, function (err) {

		});

	  $scope.keyRiskAreaInfo = function (keyRiskAreaId) {
	  	$state.go('keyRiskAreaInfo', {keyRiskAreaId: keyRiskAreaId} );
	  };

    $scope.removeFilter = function (element) {
      delete $scope.entry.searchKeyRiskArea[element];
      if (_.size($scope.entry.searchKeyRiskArea) === 0) {
        delete $scope.entry.searchKeyRiskArea;
      }
    };
    
  }
}

angular.module('amxApp')
  .component('keyRiskAreaTable', {
    templateUrl: 'app/coverage/routes/keyRiskAreaTable/keyRiskAreaTable.html',
    controller: KeyRiskAreaTableComponent,
    controllerAs: 'keyRiskAreaTableCtrl'
  });

})();
