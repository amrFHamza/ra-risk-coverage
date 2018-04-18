'use strict';

describe('Directive: heatMap', function () {

  // load the directive's module and view
  beforeEach(module('amxApp'));
  beforeEach(module('app/coverage/directives/heatMap/heatMap.html'));

  var element, scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  // it('should make hidden element visible', inject(function ($compile) {
  //   element = angular.element('<heat-map></heat-map>');
  //   element = $compile(element)(scope);
  //   scope.$apply();
  //   expect(element.text()).to.equal('this is the heatMap directive');
  // }));
});
