'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('interfaceInfo', {
        url: '/interface-info?interfaceId',
        template: '<interface-info></interface-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Interface info',
              showOpcoFilter: false
            }           
      });
  });
