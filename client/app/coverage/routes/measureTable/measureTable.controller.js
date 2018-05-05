'use strict';

(function(){

class MeasureTableComponent {
  constructor() {
    this.message = 'Hello';
  }
}

angular.module('amxApp')
  .component('measureTable', {
    templateUrl: 'app/coverage/routes/measureTable/measureTable.html',
    controller: MeasureTableComponent,
    controllerAs: 'measureTableCtrl'
  });

})();
