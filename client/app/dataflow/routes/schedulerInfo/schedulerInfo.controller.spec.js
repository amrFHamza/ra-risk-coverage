'use strict';

describe('Component: SchedulerInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var SchedulerInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    SchedulerInfoComponent = $componentController('schedulerInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
