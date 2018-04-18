'use strict';

describe('Component: RiskInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var RiskInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    RiskInfoComponent = $componentController('riskInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
