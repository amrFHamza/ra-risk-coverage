'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var dflProcedureCtrlStub = {
  index: 'dflProcedureCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var dflProcedureIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './dflProcedure.controller': dflProcedureCtrlStub
});

describe('DflProcedure API Router:', function() {

  it('should return an express router instance', function() {
    expect(dflProcedureIndex).to.equal(routerStub);
  });

  describe('GET /api/dfl-procedures', function() {

    it('should route to dflProcedure.controller.index', function() {
      expect(routerStub.get
        .withArgs('/getAllProcedures', 'dflProcedureCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
