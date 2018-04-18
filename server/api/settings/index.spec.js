'use strict';

var proxyquire = require('proxyquire').noPreserveCache();

var settingsCtrlStub = {
  index: 'settingsCtrl.index'
};

var routerStub = {
  get: sinon.spy()
};

// require the index with our stubbed out modules
var settingsIndex = proxyquire('./index.js', {
  'express': {
    Router: function() {
      return routerStub;
    }
  },
  './settings.controller': settingsCtrlStub
});

describe('Settings API Router:', function() {

  it('should return an express router instance', function() {
    expect(settingsIndex).to.equal(routerStub);
  });

  describe('GET /api/settings', function() {

    it('should route to settings.controller.index', function() {
      expect(routerStub.get
        .withArgs('/', 'settingsCtrl.index')
        ).to.have.been.calledOnce;
    });

  });

});
