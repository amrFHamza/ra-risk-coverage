'use strict';

describe('Service: Lookup', function () {

  // load the service's module
  beforeEach(module('amxApp'));

  // instantiate service
  var Lookup;
  beforeEach(inject(function (_Lookup_) {
    Lookup = _Lookup_;
  }));

  it('should do something', function () {
    expect(!!Lookup).to.be.true;
  });

});
