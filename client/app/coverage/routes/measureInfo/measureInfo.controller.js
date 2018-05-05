'use strict';

(function(){

class MeasureInfoComponent {
  constructor() {
    this.message = 'Hello';
  }
}

angular.module('amxApp')
  .component('measureInfo', {
    templateUrl: 'app/coverage/routes/measureInfo/measureInfo.html',
    controller: MeasureInfoComponent,
    controllerAs: 'measureInfoCtrl'
  });

})();
