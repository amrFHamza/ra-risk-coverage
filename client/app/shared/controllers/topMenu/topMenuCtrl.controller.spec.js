'use strict';

describe('Controller: topMenuCtrl', function () {

  // load the controller's module
  beforeEach(module('amxApp'));

  var topMenuCtrl, scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    topMenuCtrl = $controller('topMenuCtrl', {
      $scope: scope
    });
  }));

  it('should ...', function () {
    expect(1).to.equal(1);
  });
});
