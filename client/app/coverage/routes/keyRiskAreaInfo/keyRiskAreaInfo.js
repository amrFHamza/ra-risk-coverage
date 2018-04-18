'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('keyRiskAreaInfo', {
        url: '/key-risk-area-info?keyRiskAreaId',
        template: '<key-risk-area-info></key-risk-area-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Risk catalogue',
              title: 'Key risk area info',
              showOpcoFilter: false
            }
      });
  });
