'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('schedulerTable', {
        url: '/scheduler-catalogue?opcoId',
        template: '<scheduler-table></scheduler-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Schedulers',
              showOpcoFilter: true
            }
      });
  });
