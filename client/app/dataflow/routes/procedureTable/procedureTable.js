'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('procedureTable', {
        url: '/procedure-catalogue?opcoId',
        template: '<procedure-table></procedure-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Procedures',
              showOpcoFilter: true
            }             
      });
  });
