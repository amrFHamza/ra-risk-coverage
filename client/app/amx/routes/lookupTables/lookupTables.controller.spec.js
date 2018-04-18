'use strict';

describe('Component: LookupTablesComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var LookupTablesComponent, scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController, $rootScope) {
    scope = $rootScope.$new();
    LookupTablesComponent = $componentController('lookupTables', {
      $scope: scope
    });
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
