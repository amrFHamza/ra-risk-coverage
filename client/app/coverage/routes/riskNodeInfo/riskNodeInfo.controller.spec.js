'use strict';

describe('Component: RiskNodeInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var RiskNodeInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    RiskNodeInfoComponent = $componentController('riskNodeInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
