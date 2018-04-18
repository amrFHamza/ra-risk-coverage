'use strict';

(function(){

class ProductSegmentInfoComponent {
  constructor() {
    this.message = 'Hello';
  }
}

angular.module('amxApp')
  .component('productSegmentInfo', {
    templateUrl: 'app/coverage/routes/productSegmentInfo/productSegmentInfo.html',
    controller: ProductSegmentInfoComponent,
    controllerAs: 'productSegmentInfoCtrl'
  });

})();
