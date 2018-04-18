'use strict';

describe('Component: InterfaceTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var InterfaceTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    InterfaceTableComponent = $componentController('interfaceTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
