'use strict';

describe('Component: ProcedureTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var ProcedureTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    ProcedureTableComponent = $componentController('procedureTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
