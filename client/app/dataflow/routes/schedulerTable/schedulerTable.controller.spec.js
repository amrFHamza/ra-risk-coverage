'use strict';

describe('Component: SchedulerTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var SchedulerTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    SchedulerTableComponent = $componentController('schedulerTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
