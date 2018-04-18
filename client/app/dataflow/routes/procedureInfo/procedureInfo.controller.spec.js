'use strict';

describe('Component: ProcedureInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var ProcedureInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    ProcedureInfoComponent = $componentController('procedureInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
