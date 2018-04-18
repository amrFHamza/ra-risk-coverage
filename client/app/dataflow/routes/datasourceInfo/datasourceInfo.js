'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('datasourceInfo', {
        url: '/datasource-info?datasourceId',
        template: '<datasource-info></datasource-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Datasource info',
              showOpcoFilter: false
            }           
      });
  });
