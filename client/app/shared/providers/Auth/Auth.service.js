'use strict';
/* globals CryptoJS */

angular.module('amxApp')
  .factory('Auth', function ($rootScope, Entry, $http, $q, $uibModal, $cookies) {
    // Service logic
    
    // ...
    return {
      login: (function () {
        Entry.currentUser.loginInProgress = true;
        // Modal controller
        function loginCtrl ($scope, $uibModalInstance) {

          // Authenticator function
          function login (user, password) {
            return $http.post('/api/users/login', {postUser: user, postPassword: CryptoJS.SHA256(password).toString(CryptoJS.enc.Hex)})
              .then(function(response) {
                  if (typeof response.data === 'object' && response.data.userAuth) {
                      
                      if (response.data.userToken === '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8') {
                        Entry.showToast(response.data.userAlias + ' successfully signed in. Please change your password !!!');
                      }
                      else {
                        // User successfully authenticated return data
                        Entry.showToast(response.data.userAlias + ' successfully signed in.','customAlert');
                      }                      
                      return response.data;                  
                  } else {
                      // invalid response
                      $rootScope.entry.currentUser.userAuthFailed += 1;
                      Entry.showToast( 'Sign in failed! Please try again.');
                      return $q.reject(response.data);
                  }

              }, function(response) {
                  // something went wrong
                  Entry.showToast( 'Sign in failure!');
                  return $q.reject(response.data);
              });
          }

          // Cancel login process
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };

          // Login submitted
          $scope.submit = function () {
            login($scope.form.email, $scope.form.password)
              .then(function (data) {
                $uibModalInstance.close(data);
            });
          };
        }

        return function() {
          var instance = $uibModal.open({
            templateUrl: 'app/shared/providers/Auth/login-modal.html',
            controller: loginCtrl
          });

          return instance.result.then(function (data) {
            $rootScope.entry.currentUser = data;
            $rootScope.entry.currentUser.userOpcoId = Number($rootScope.entry.currentUser.userOpcoId);
            $rootScope.entry.OPCO_ID = Number($cookies.get('OPCO_ID')) || $rootScope.entry.currentUser.userOpcoId;

            // user sucessfully authenticated - update cookies
            $cookies.put('userAuth', $rootScope.entry.currentUser.userAuth, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userName', $rootScope.entry.currentUser.userName, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userAlias', $rootScope.entry.currentUser.userAlias, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userToken', $rootScope.entry.currentUser.userToken, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userOpcoName', $rootScope.entry.currentUser.userOpcoName, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userOpcoId', $rootScope.entry.currentUser.userOpcoId, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userAccessLevel', $rootScope.entry.currentUser.userAccessLevel, {expires: $rootScope.entry.getExpiryDate()});
            $cookies.put('userMessageConfig', JSON.stringify($rootScope.entry.currentUser.userMessageConfig), {expires: $rootScope.entry.getExpiryDate()});

            Entry.currentUser.loginInProgress = false;
            return true;
          });
        };        

      })(),
      changePassword: (function () {

        function changePasswordCtrl($scope, $uibModalInstance) {

          $scope.entry = Entry;

          function changePassword (user, password){
            return $http.post('/api/users/changePassword', {postUser: user, postPassword: CryptoJS.SHA256(password).toString(CryptoJS.enc.Hex)})
              .then(function(response) {
                  if (typeof response.data === 'object' && response.data.success) {
                      return response.data;
                  } else {
                      // invalid response
                      return $q.reject(response.data);
                  }

              }, function(response) {
                  // something went wrong
                  return $q.reject(response.data);
              });      
          }
          
          
          $scope.cancel = function () {
            $uibModalInstance.dismiss('cancel');
          };

          $scope.submit = function () {
            if (typeof $scope.form == 'undefined') {
              $scope.entry.currentUser.passwordChangeFailed = 'Password can\'t be blank!';
            }
            else if ($scope.form.newPassword != $scope.form.newPasswordCheck){
              $scope.entry.currentUser.passwordChangeFailed = 'Passwords do not match!';
            }
            else if ($scope.form.newPassword.length < 6) {
              $scope.entry.currentUser.passwordChangeFailed = 'New password must be at least 6 characters long!';
            }
            else if (CryptoJS.SHA256($scope.form.newPassword).toString(CryptoJS.enc.Hex) === $scope.entry.currentUser.userToken ) {
              $scope.entry.currentUser.passwordChangeFailed = 'New password must be different from the current !';
            }
            else {
              changePassword($scope.entry.currentUser.userName, $scope.form.newPassword).then(function (data) {
                $uibModalInstance.close(data);
                $scope.entry.currentUser.passwordChangeFailed = false;
                // Update the userToken cookie
                $scope.entry.currentUser.userToken = CryptoJS.SHA256($scope.form.newPassword).toString(CryptoJS.enc.Hex);
                $cookies.put('userToken', $scope.entry.currentUser.userToken, {expires: $rootScope.entry.getExpiryDate()});
                Entry.showToast('Your password.  was successfully changed!');
              });
            }
          };

        }

        return function() {
          var instance = $uibModal.open({
            templateUrl: 'app/shared/providers/Auth/change-password-modal.html',
            controller: changePasswordCtrl,
          });
          return instance.result.then(function (data){return data;});
        };

      })(),
      saveMessageConfig: function (userData){
        return $http({
          url: '/api/users/saveMessageConfig', 
          method: 'POST',
          data: userData
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      }   
    };
  });
