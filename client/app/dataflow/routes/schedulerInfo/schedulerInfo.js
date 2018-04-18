'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('schedulerInfo', {
        url: '/scheduler-info?schedulerId',
        template: '<scheduler-info></scheduler-info>',
        data: {
              requireLogin: true,
              leftMenu: 'Dataflow',
              title: 'Schedulers',
              showOpcoFilter: true
            }         
      });
  });
