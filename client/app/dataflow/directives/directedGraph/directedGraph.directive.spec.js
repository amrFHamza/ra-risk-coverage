'use strict';

describe('Directive: directedGraph', function () {

  // load the directive's module and view
  beforeEach(module('amxApp'));

  var element, scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
    scope.directedGraphConfig = {
      links:  [
                {source: 'test', target: 'test', type: 'resolved'},
              ]
    };    
  }));

  // it('should make hidden element visible', inject(function ($compile) {
  //   element = angular.element('<directed-graph config="directedGraphConfig"></directed-graph>');
  //   element = $compile(element)(scope);
  //   scope.$apply();
  //   expect(element).to.be.defined;
  // }));
  
});
