'use strict';

angular.module('amxApp')
  .factory('Lookup', function ($http, $state,  $q) {
    // Service logic
    // ...
    return {
      lookup: function(lookup, opcoId){
        return $http({
          url: '/api/lookups/' + lookup, 
          method: 'GET',
          params: {opcoId: opcoId}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            $state.go('settings', {}, {reload: true});
            return $q.reject(response.data);
          });
      },
      delete: function (lookupTable, id) {
        return $http({
          url: '/api/lookups/' + lookupTable, 
          method: 'DELETE',
          params: {id: id}
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });     
      },
      postFlashUpdate: function (lookupTable, data) {
        return $http({
          url: '/api/lookups/postFlashUpdate/' + lookupTable, 
          method: 'POST',
          data: data
        })
        .then(function(response) {
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });     
      },
      getOverview: function(frequency, opcoId, finetuneFilter){
        return $http({
          url: '/api/lookups/getOverview', 
          method: 'GET',
          params: {frequency: frequency, opcoId: opcoId, finetuneFilter: finetuneFilter}
        })
        .then(function(response) {    
            for (var i=0; i<response.data.length; i++) {
              response.data[i].MONTH = moment(response.data[i].MONTH, 'YYYY-MM').toDate();  
            }             
            return response.data;
          }, function(response) {
            return $q.reject(response.data);
          });
      }      
    }; 
  });
