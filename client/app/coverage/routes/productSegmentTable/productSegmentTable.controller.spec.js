'use strict';

describe('Component: ProductSegmentTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var ProductSegmentTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    ProductSegmentTableComponent = $componentController('productSegmentTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
