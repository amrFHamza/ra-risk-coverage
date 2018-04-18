'use strict';

describe('Component: RiskTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var RiskTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    RiskTableComponent = $componentController('riskTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
