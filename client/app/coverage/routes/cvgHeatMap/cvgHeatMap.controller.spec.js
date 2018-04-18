'use strict';

describe('Component: CvgHeatMapComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var CvgHeatMapComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    CvgHeatMapComponent = $componentController('cvgHeatMap', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
