'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('productSegmentCompare', {
        url: '/product-segment-compare?productSegmentIdA&amp;productSegmentIdB',
        template: '<product-segment-compare></product-segment-compare>',
        data: {
              requireLogin: true,
              leftMenu: 'Coverage',
              title: 'Compare product segments',
              showOpcoFilter: false
            }         
      });
  });
