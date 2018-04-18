'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('riskInfo', {
        url: '/risk-info?riskId?subProcessId',
        template: '<risk-info></risk-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Risk catalogue',
              title: 'Risk info',
              showOpcoFilter: false
            }           
      });
  });
