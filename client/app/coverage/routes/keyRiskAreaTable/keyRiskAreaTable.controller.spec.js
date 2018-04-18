'use strict';

describe('Component: KeyRiskAreaTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var KeyRiskAreaTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    KeyRiskAreaTableComponent = $componentController('keyRiskAreaTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
