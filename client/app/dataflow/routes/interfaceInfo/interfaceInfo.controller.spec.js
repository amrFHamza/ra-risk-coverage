'use strict';

describe('Component: InterfaceInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var InterfaceInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    InterfaceInfoComponent = $componentController('interfaceInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
