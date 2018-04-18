'use strict';

angular.module('amxApp')
  .factory('ConfirmModal', function ($rootScope, $uibModal) {
    // Service logic
    // ...

    function confirmModalCtrl ($scope, $uibModalInstance, Entry, confirmText) {
      $scope.confirmText = confirmText;

      $scope.modalCancel = function () {
        $uibModalInstance.dismiss('User cancel');
      };

      $scope.modalSubmit = function () {
        $uibModalInstance.close(true);
      };
    } 

    return function(confirmText) {
      // console.log(confirmText);
      var instance = $uibModal.open({
        templateUrl: 'app/shared/providers/ConfirmModal/confirm-modal.html',
        controller: confirmModalCtrl,
        resolve: {
          confirmText: function () {return confirmText;}
        }
      });
      return instance.result.then(function (data){return data;});
    };
  });
