'use strict';

var app = require('../..');
import request from 'supertest';

describe('Coverage API:', function() {

  describe('GET /api/coverage', function() {
    var coverages;

    beforeEach(function(done) {
      request(app)
        .get('/api/coverage/getRisks')
        .expect(401)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          coverages = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(coverages).to.be.instanceOf(Object);
    });

  });

});
