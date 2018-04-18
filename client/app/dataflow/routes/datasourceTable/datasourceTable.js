'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('datasourceTable', {
        url: '/datasource-catalogue?opcoId',
        template: '<datasource-table></datasource-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Datasources',
              showOpcoFilter: true
            }           
      });
  });
