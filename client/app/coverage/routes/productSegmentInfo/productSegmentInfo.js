'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('productSegmentInfo', {
        url: '/product-segment-info?productSegmentId',
        template: '<product-segment-info></product-segment-info>',
				data: {
        			requireLogin: true,
        			title: 'Product segment info',
        			leftMenu: 'Coverage',
        			showOpcoFilter: false
      			}          
      });
  });
