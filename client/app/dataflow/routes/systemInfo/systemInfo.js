'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('systemInfo', {
        url: '/system-info?systemId',
        template: '<system-info></system-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'System info',
              showOpcoFilter: false
            }           
      });
  });
