'use strict';

angular.module('amxApp')
  .factory('CommentModal', function ($rootScope, $uibModal) {
    // Service logic
    // ...

    function commentModalCtrl ($scope, $uibModalInstance, Change, Entry) {
      $scope.change = {};

      $scope.modalCancel = function () {
        $uibModalInstance.dismiss('User cancel');
      };

      $scope.modalSubmit = function () {
        $uibModalInstance.close($scope.form);
      };
    } 

    return function() {
      var instance = $uibModal.open({
        templateUrl: 'app/amx/providers/CommentModal/comment-modal.html',
        controller: commentModalCtrl
      });
      return instance.result.then(function (data){return data;});
    };
  });
