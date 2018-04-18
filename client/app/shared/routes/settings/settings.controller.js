'use strict';

(function(){

class SettingsComponent {
constructor($scope, $http, Entry, ConfirmModal) {
    $scope.entry = Entry;
    $scope.loadFinished = true;

    $scope.importModel = function(model){

      ConfirmModal('The current DB schema will be completely overwritten - please ensure you have backup first! Are you sure you want to load the "' + model +'" risk model?')
      .then(function(confirmResult) {
        if (confirmResult) {
          // if confirmed
          $scope.loadFinished = false;

          $http({
            method: 'GET',
            url: '/api/settings/importRiskCatalogue',
            params: {riskCatalogue : model}
          }).then(function (response) {
            Entry.showToast(model + ' model loaded. You need to configure the environment before first use!');
            $scope.loadFinished = true;
          }, function (err) {
            $scope.loadFinished = true;
            Entry.showToast('Load failed! Try manual importing.');
          });
          // if confirmed
        }
      })
      .catch(function(err) {
        Entry.showToast('Action cancelled');
      });  

    };

  }
}

angular.module('amxApp')
  .component('settings', {
    templateUrl: 'app/shared/routes/settings/settings.html',
    controller: SettingsComponent,
    controllerAs: 'settingsCtrl'
  });

})();
