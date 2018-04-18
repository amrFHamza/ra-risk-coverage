'use strict';

describe('Service: Coverage', function () {

  // load the service's module
  beforeEach(module('amxApp'));

  // instantiate service
  var Coverage;
  beforeEach(inject(function (_Coverage_) {
    Coverage = _Coverage_;
  }));

  it('should do something', function () {
    expect(!!Coverage).to.be.true;
  });

});
