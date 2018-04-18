'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('riskNodeInfo', {
        url: '/risk-node-info?riskNodeId',
        template: '<risk-node-info></risk-node-info>',
				data: {
        			requireLogin: true,
        			title: 'Risk node info',
        			leftMenu: 'Coverage',
        			showOpcoFilter: false
      			}        
      });
  });
