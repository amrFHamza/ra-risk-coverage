'use strict';

describe('Component: DatasourceTableComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var DatasourceTableComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    DatasourceTableComponent = $componentController('datasourceTable', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
