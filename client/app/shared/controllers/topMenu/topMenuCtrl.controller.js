'use strict';

function topMenuCtrl($scope, $mdSidenav, Entry, Auth, $state, $cookies) {

    $scope.entry = Entry;

    $scope.toggleLeft = function() {
      $mdSidenav('left').toggle();
    };

    $scope.login = function() {
        Auth.login().then(function() {
            $state.go('overview');
        });
    };

    $scope.logout = function() {
      $scope.entry.currentUser = {userAuth: false, userAuthFailed: 0};  
      $cookies.remove('userAuth');
      $cookies.remove('userName');
      $cookies.remove('userAlias');
      $cookies.remove('userToken');
      $cookies.remove('userOpcoName');
      $cookies.remove('userOpcoId');
      $cookies.remove('userAccessLevel');
      $cookies.remove('userMessageConfig');
      $cookies.remove('OPCO_ID');
      $cookies.remove('OPCO_NAME');
      Entry.showToast('Signed out');
      $state.go('overview');
    };

    $scope.changePassword = function() {
        Auth.changePassword().then(function() {
            // $scope.entry.currentUser = {userAuth: false, userAuthFailed: 0};  
            // $cookies.remove('userAuth');
            // $cookies.remove('userName');
            // $cookies.remove('userAlias');
            // $cookies.remove('userToken');
            // $cookies.remove('userOpcoName');
            // $cookies.remove('userOpcoId');
            // $cookies.remove('userAccessLevel');
            // $cookies.remove('userMessageConfig');
            // $cookies.remove('OPCO_ID');
            // $cookies.remove('OPCO_NAME');
            // Entry.showToast('Please log in with your new password!');
            // Auth.login().then(function() {
            //     $state.go('overview');
            // });
        });        
    };


}

angular.module('amxApp')
  .controller('topMenuCtrl', topMenuCtrl);
