'use strict';

describe('Component: SystemTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var SystemTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    SystemTableComponent = $componentController('systemTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
