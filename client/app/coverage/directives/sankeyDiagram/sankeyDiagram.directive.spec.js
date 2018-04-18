'use strict';

describe('Directive: sankeyDiagram', function () {

  // load the directive's module and view
  beforeEach(module('amxApp'));
  beforeEach(module('app/coverage/directives/sankeyDiagram/sankeyDiagram.html'));

  var element, scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  // it('should make hidden element visible', inject(function ($compile) {
  //   element = angular.element('<sankey-diagram></sankey-diagram>');
  //   element = $compile(element)(scope);
  //   scope.$apply();
  //   expect(element.text()).to.equal('this is the sankeyDiagram directive');
  // }));
});
