'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('riskNodeTable', {
        url: '/risk-nodes?productSegmentId?riskId?tabId',
        template: '<risk-node-table></risk-node-table>',
				data: {
        			requireLogin: true,
        			title: 'Risk nodes',
        			leftMenu: 'Coverage',
        			showOpcoFilter: false
      			}
      });
  });
