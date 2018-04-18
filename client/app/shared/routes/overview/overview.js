'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('overview', {
        url: '/coverage-overview?opcoId',
        template: '<overview></overview>',
        data: {
              requireLogin: true,
              leftMenu: 'Coverage',
              title: 'Overview',
              showOpcoFilter: true
            }          
      });
  });
