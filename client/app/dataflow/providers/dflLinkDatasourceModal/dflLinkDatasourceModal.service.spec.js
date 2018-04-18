'use strict';

describe('Service: dflLinkDatasourceModal', function () {

  // load the service's module
  beforeEach(module('amxApp'));

  // instantiate service
  var dflLinkDatasourceModal;
  beforeEach(inject(function (_dflLinkDatasourceModal_) {
    dflLinkDatasourceModal = _dflLinkDatasourceModal_;
  }));

  it('should do something', function () {
    expect(!!dflLinkDatasourceModal).to.be.true;
  });

});
