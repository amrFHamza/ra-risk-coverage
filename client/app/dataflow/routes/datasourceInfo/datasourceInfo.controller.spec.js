'use strict';

describe('Component: DatasourceInfoComponent', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var DatasourceInfoComponent;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($componentController) {
    DatasourceInfoComponent = $componentController('datasourceInfo', {});
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
