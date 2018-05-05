'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('measureInfo', {
        url: '/measure-info?measureId',
        template: '<measure-info></measure-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Risk catalogue',
              title: 'Generic measure info',
              showOpcoFilter: false
            }        
      });
  });
