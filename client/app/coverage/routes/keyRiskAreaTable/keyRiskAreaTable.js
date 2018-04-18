'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('keyRiskAreaTable', {
        url: '/key-risk-areas',
        template: '<key-risk-area-table></key-risk-area-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Risk catalogue',
              title: 'Key risk areas',
              showOpcoFilter: false
            }        
      });
  });
