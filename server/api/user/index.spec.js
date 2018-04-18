'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var userCtrlStub = {
  index: 'userCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var userIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './user.controller': userCtrlStub
});

describe('User API Router:', function() {

  it('should return an express router instance', function() {
    expect(userIndex).to.equal(routerStub);
  });

  describe('GET /api/users', function() {

    it('should route to user.controller.index', function() {
      expect(routerStub.get
        .withArgs('/', 'userCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
