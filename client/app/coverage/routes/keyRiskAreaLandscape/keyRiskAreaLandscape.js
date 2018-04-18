'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('keyRiskAreaLandscape', {
        url: '/ra-landscape?opcoId',
        template: '<key-risk-area-landscape></key-risk-area-landscape>',
        data: {
              requireLogin: true,
              leftMenu: 'Coverage',
              title: 'Key Risk Areas - landcape',
              showOpcoFilter: true
            }        
      });
  });
