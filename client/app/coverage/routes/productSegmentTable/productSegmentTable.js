'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('productSegmentTable', {
        url: '/product-segments?opcoId',
        template: '<product-segment-table></product-segment-table>',
				data: {
        			requireLogin: true,
        			title: 'Product segments',
        			leftMenu: 'Coverage',
        			showOpcoFilter: true
      			}           
      });
  });
