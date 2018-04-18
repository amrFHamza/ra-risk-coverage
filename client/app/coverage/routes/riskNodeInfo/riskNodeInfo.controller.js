'use strict';

(function(){

class RiskNodeInfoComponent {
  constructor() {
    this.message = 'Hello';
  }
}

angular.module('amxApp')
  .component('riskNodeInfo', {
    templateUrl: 'app/coverage/routes/riskNodeInfo/riskNodeInfo.html',
    controller: RiskNodeInfoComponent,
    controllerAs: 'riskNodeInfoCtrl'
  });

})();
