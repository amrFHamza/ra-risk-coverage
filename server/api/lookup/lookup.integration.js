'use strict';

var app = require('../..');
import request from 'supertest';

describe('Lookup API:', function() {

  describe('GET /api/lookups', function() {
    var lookups;

    beforeEach(function(done) {
      request(app)
        .get('/api/lookups/getCountersAll')
        .expect(200)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          lookups = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(lookups).to.be.instanceOf(Array);
    });

  });

});
