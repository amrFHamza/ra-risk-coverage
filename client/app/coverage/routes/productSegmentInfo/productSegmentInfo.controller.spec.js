'use strict';

describe('Component: ProductSegmentInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var ProductSegmentInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    ProductSegmentInfoComponent = $componentController('productSegmentInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
