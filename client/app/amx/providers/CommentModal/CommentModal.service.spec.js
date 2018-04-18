'use strict';

describe('Service: CommentModal', function () {

  // load the service's module
  beforeEach(module('amxApp'));

  // instantiate service
  var CommentModal;
  beforeEach(inject(function (_CommentModal_) {
    CommentModal = _CommentModal_;
  }));

  it('should do something', function () {
    expect(!!CommentModal).to.be.true;
  });

});
