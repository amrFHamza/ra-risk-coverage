'use strict';

describe('Component: OverviewComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var OverviewComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    OverviewComponent = $componentController('overview', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
