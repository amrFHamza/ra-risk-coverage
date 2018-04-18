'use strict';

describe('Service: Entry', function () {

  // load the service's module
  beforeEach(module('amxApp'));

  // instantiate service
  var Entry;
  beforeEach(inject(function (_Entry_) {
    Entry = _Entry_;
  }));

  it('should do something', function () {
    expect(!!Entry).to.be.true;
  });

});
