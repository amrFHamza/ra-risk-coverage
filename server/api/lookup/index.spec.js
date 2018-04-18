'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var lookupCtrlStub = {
  index: 'lookupCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var lookupIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './lookup.controller': lookupCtrlStub
});

describe('Lookup API Router:', function() {

  it('should return an express router instance', function() {
    expect(lookupIndex).to.equal(routerStub);
  });

  describe('GET /api/lookups', function() {

    it('should route to lookup.controller.index', function() {
      expect(routerStub.get
        .withArgs('/', 'lookupCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
