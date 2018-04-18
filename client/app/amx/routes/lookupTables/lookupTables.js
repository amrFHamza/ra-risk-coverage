'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('lookupTables', {
        url: '/lookup-tables',
        template: '<lookup-tables></lookup-tables>',
				data: {
        			requireLogin: false,
        			title: 'Lookup tables',
        			leftMenu: 'Lookup tables',
        			showOpcoFilter: true
      			}        
      });
  });
