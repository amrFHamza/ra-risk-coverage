'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var coverageCtrlStub = {
  index: 'coverageCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var coverageIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './coverage.controller': coverageCtrlStub
});

describe('Coverage API Router:', function() {

  it('should return an express router instance', function() {
    expect(coverageIndex).to.equal(routerStub);
  });

  describe('GET /api/coverage/getRiskCatalogue', function() {

    it('should route to coverage.controller.index', function() {
      expect(routerStub.get
        .withArgs('/', 'coverageCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
