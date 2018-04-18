'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var dflDatasourceCtrlStub = {
  index: 'dflDatasourceCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var dflDatasourceIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './dflDatasource.controller': dflDatasourceCtrlStub
});

describe('DflDatasource API Router:', function() {

  it('should return an express router instance', function() {
    expect(dflDatasourceIndex).to.equal(routerStub);
  });

  describe('GET /api/dfl-datasources', function() {

    it('should route to dflDatasource.controller.index', function() {
      expect(routerStub.get
        .withArgs('/getAllDatasources', 'dflDatasourceCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
