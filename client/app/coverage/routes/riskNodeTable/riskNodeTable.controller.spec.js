'use strict';

describe('Component: RiskNodeTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var RiskNodeTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    RiskNodeTableComponent = $componentController('riskNodeTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
