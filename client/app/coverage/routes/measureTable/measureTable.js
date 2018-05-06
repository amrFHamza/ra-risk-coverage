'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('measureTable', {
        url: '/measures',
        template: '<measure-table></measure-table>',
        data: {
              requireLogin: true,
              leftMenu: 'Risk catalogue',
              title: 'Generic measure catalogue',
              showOpcoFilter: false
            }        
      });
  });
