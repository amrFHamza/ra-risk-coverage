'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('settings', {
        url: '/settings',
        template: '<settings></settings>',
        data: {
              requireLogin: false,
              leftMenu: 'Settings',
              title: 'Settings',
              showOpcoFilter: false
            }         
      });
  });
