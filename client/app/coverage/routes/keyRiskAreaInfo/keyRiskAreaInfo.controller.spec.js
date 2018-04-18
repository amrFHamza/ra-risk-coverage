'use strict';

describe('Component: KeyRiskAreaInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var KeyRiskAreaInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    KeyRiskAreaInfoComponent = $componentController('keyRiskAreaInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
