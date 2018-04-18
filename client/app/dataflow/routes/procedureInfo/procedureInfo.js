'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('procedureInfo', {
        url: '/procedure-info?procedureId',
        template: '<procedure-info></procedure-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Procedure info',
              showOpcoFilter: false
            }          
  		});
	});