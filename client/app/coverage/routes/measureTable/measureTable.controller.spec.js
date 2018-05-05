'use strict';

describe('Component: MeasureTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var MeasureTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    MeasureTableComponent = $componentController('measureTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
