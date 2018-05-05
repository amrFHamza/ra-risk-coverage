'use strict';

describe('Component: MeasureInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var MeasureInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    MeasureInfoComponent = $componentController('measureInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
