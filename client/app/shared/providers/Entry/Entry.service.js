'use strict';

angular.module('amxApp')
  .factory('Entry', function ($cookies, $mdToast) {
    // Service logic
    // ...

    var entry = {
        currentUser: {
            loginInProgress: false
        }
    };

    // Overview fine-tuned filter
    entry.overviewShowFineTunedOnly = 'Y';

    // default date sort order
    entry.reverse = true;

    entry.searchRiskCatalogue = {};

    entry.searchHeatMap = {};
    entry.searchHeatMap.showRPN = true;
    entry.searchHeatMap.mapValue = 'Total';
    entry.searchHeatMap.mapType = 'Risk / System';
    entry.searchHeatMap.initialSort = {'col': [], 'row': []};

    entry.searchMDmonth = moment().format('YYYY-MM');
    
    entry.searchKeyRiskArea = {};
    entry.showRiskAreaDetails = 'N';
    entry.showRiskAreaExpand = 'N';
    entry.showMeasures = true;


    entry.currMonth = moment().format('YYYY-MM');
    entry.currDay = moment().format('DD.MM.YYYY');

    if ($cookies.get('OPCO_ID')) {
        entry.OPCO_ID = Number($cookies.get('OPCO_ID'));
    }
    else if (entry.currentUser.userOpcoId) {
        entry.OPCO_ID = Number(entry.currentUser.userOpcoId);
    }
    else {
        delete entry.OPCO_ID;   
    }

    entry.isDisabled = function() {
        return false;
        // return Number(entry.OPCO_ID) !== (entry.currentUser && Number(entry.currentUser.userOpcoId));
    };

    entry.getExpiryDate = function () {
        var date = new Date();
        var expiryDate = new Date(date.getTime() + 24 * 3600 * 1000);
        return expiryDate;
    };  

    entry.showToast = function(showText){
        $mdToast.show(
            $mdToast.simple()
                .textContent(showText)
                .position('bottom right')
                .hideDelay(4000)
        );        
    };

    // Public API here
    return entry;

  });
