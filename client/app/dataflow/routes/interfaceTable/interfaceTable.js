'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('interfaceTable', {
        url: '/interface-catalogue?opcoId',
        template: '<interface-table></interface-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Interfaces',
              showOpcoFilter: true
            }           
      });
  });
