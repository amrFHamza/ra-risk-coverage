'use strict';

var app = require('../..');
import request from 'supertest';

describe('User API:', function() {

  describe('GET /api/users', function() {
    var users;

    beforeEach(function(done) {
      request(app)
        .get('/api/users')
        .expect(200)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          users = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(users).to.be.instanceOf(Array);
    });

  });

});
