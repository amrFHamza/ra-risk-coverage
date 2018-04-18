'use strict';

describe('Component: DataflowGraphComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var DataflowGraphComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    DataflowGraphComponent = $componentController('dataflowGraph', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
