'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('systemTable', {
        url: '/system-catalogue?opcoId',
        template: '<system-table></system-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Systems',
              showOpcoFilter: true
            }           
      });
  });
