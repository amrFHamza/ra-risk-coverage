'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('riskTable', {
        url: '/risk-catalogue',
        template: '<risk-table></risk-table>',
				data: {
        			requireLogin: true,
        			title: 'Risk catalogue',
        			leftMenu: 'Risk catalogue',
        			showOpcoFilter: false
      			}         
      });
  });
