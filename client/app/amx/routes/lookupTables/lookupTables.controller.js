'use strict';
(function(){

class LookupTablesComponent {
  constructor($scope, Lookup, Entry, ConfirmModal) {
    $scope.entry = Entry;
    $scope.currDate = moment().format('YYYYMMDD');

    $scope.reglasFile = [];
    $scope.reglasFile.lines = null;
    $scope.reglasFile.header = ['ID_DATO', 'DESCRIPCION_VC', 'DESFASE', '11', '12', '13', '14', '15', '16', '21', '22', '23', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45', '51', '52', '53', '54', '55', '56', '57', '58', '59', '510', '511', '512', '513', '514', '515'];

    $scope.finetuneStatusFile = [];
    $scope.finetuneStatusFile.lines = null;
    $scope.finetuneStatusFile.header = ['OPCO_ID', 'COUNTRY', 'OPCO_NAME', 'METRIC_ID', 'RELEVANT', 'NAME', 'DESCRIPTION', 'FREQUENCY', 'FORMULA', 'OBJECTIVE', 'TOLERANCE','STATUS', 'TASK_STATUS', 'TASK_DESCRIPTION / NOTES'];

    $scope.addSystem = function() {
      var system = {
        'NAME' : '',
        'DESCRIPTION' : '',
        'OPCO_ID' : $scope.entry.currentUser.userOpcoId
      };
      $scope.entry.lookup.systems.push(system);
      //$scope.saveSystem();
    };

    $scope.deleteSystem = function(systemId) {
      ConfirmModal('Are you sure you want to delete system "' + $scope.entry.lookup.getSystemById(systemId).NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
          Lookup.delete('system', systemId).then(function (data) {
            if (data.success){
                Entry.showToast('System "' + $scope.entry.lookup.getSystemById(systemId).NAME + '" deleted');
                $scope.entry.lookup.systems = _.reject($scope.entry.lookup.systems, function (num) {
                  return num.SYSTEM_ID === systemId;
                });
            }
            else {
              Entry.showToast('ERROR: Failed to delete system !' + $scope.entry.lookup.getSystemById(systemId).NAME + '<br><small>' + data.error.code + ', this system is still linked with a dato layout. Please remove all system references before deleting.</small>');
            }
          }); 
        }
      })
      .catch(function err() {
            Entry.showToast('Delete action canceled');
      });

    };

    $scope.saveSystem = function () {
      Lookup.postFlashUpdate('system', $scope.entry.lookup.systems)
      .then(function (data) {
        if (data.success){
          Entry.showToast('Changes saved');
          Lookup.lookup('getSystems').then(function (data) {
            $scope.entry.lookup.systems = data;
          });
        }
        else {
          switch (data.error.errno){
            default: Entry.showToast('Update failed. Error ' + data.error.code); break;
          }
        }
      });   
    };
    
    $scope.addContact = function() {
      var contact = {
        'NAME' : '',
        'EMAIL' : '',
        'CONTACT_TYPE' : 'P',
        'OPCO_ID' : $scope.entry.currentUser.userOpcoId
      };
      $scope.entry.lookup.contacts.push(contact);
      //$scope.saveContact();
    };

    $scope.deleteContact = function(contactId) {
      ConfirmModal('Are you sure you want to delete contact "' + $scope.entry.lookup.getContactById(contactId).NAME + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
          Lookup.delete('contact', contactId).then(function (data) {
            if (data.success){
                Entry.showToast('Contact "' + $scope.entry.lookup.getContactById(contactId).NAME + '" deleted');
                $scope.entry.lookup.contacts = _.reject($scope.entry.lookup.contacts, function (num) {
                  return num.CONTACT_ID === contactId;
                });
            }
            else {
              Entry.showToast('Failed to delete contact ' + $scope.entry.lookup.getContactById(contactId).NAME + '. ' + data.error.code + ', this contact is still linked with a dato layout. Please remove all references before deleting.');
            }
          }); 
        }
      })
      .catch(function err() {
            Entry.showToast('Delete action canceled');
      }); 
    };

    $scope.saveContact = function () {
      Lookup.postFlashUpdate('contact', $scope.entry.lookup.contacts)
      .then(function (data) {
        if (data.success){
          Entry.showToast('Changes saved');
          Lookup.lookup('getContacts').then(function (data) {
            $scope.entry.lookup.contacts = data;
          });
        }
        else {
          switch (data.error.errno){
            default: Entry.showToast('Update failed. Error ' + data.error.code); break;
          }
        }
      });   
    };

    $scope.addCycle = function() {
    	var cycle = {
    		'BILL_CYCLE' : '',
    		'DESCRIPTION' : '',
    		'OPCO_ID' : $scope.entry.currentUser.userOpcoId
    	};
    	$scope.entry.lookup.billCycles.push(cycle);
    	//$scope.saveCycle();
    };

    $scope.deleteCycle = function(cycleId) {
      ConfirmModal('Are you sure you want to delete cycle "' + $scope.entry.lookup.getBillCycleById(cycleId).DESCRIPTION + '" ?')
      .then(function(confirmResult) {
        if (confirmResult) {
        	Lookup.delete('cycle', cycleId).then(function (data) {
      			if (data.success){
      					Entry.showToast('Bill cycle "' + $scope.entry.lookup.getBillCycleById(cycleId).BILL_CYCLE + '" deleted');
      			  	$scope.entry.lookup.billCycles = _.reject($scope.entry.lookup.billCycles, function (num) {
      			  		return num.BILL_CYCLE_ID === cycleId;
      			  	});
      			}
      			else {
      				Entry.showToast('Failed to delete bill cycle ' + $scope.entry.lookup.getBillCycleById(cycleId).BILL_CYCLE + '. <br><small>' + data.error.code + ', this cycle is still linked with a dato layout. Please remove all references before deleting.</small>');
      			}
      		}); 
        }
      })
      .catch(function err() {
            Entry.showToast('Delete action canceled');
      });   
    };

    $scope.saveCycle = function () {
      Lookup.postFlashUpdate('cycle', $scope.entry.lookup.billCycles)
      .then(function (data) {
        if (data.success){
  				Entry.showToast('Changes saved');
  				Lookup.lookup('getBillCycles').then(function (data) {
  			    $scope.entry.lookup.billCycles = data;
  			  });
        }
        else {
          switch (data.error.errno){
            default: Entry.showToast('Update failed. Error ' + data.error.code); break;
          }
        }
      });  	
    };
  }
}

angular.module('amxApp')
  .component('lookupTables', {
    templateUrl: 'app/amx/routes/lookupTables/lookupTables.html',
    controller: LookupTablesComponent
  });

})();
