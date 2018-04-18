'use strict';

angular.module('amxApp')
  .config(function ($stateProvider) {
    $stateProvider
      .state('cvgHeatMap', {
        url: '/coverage-heat-maps?opcoId',
        template: '<cvg-heat-map></cvg-heat-map>',
        data: {
              requireLogin: true,
              leftMenu: 'Coverage',
              title: 'Risk heat map',
              showOpcoFilter: true
            }             
      });
  });
