'use strict';

describe('Component: SystemInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var SystemInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    SystemInfoComponent = $componentController('systemInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
