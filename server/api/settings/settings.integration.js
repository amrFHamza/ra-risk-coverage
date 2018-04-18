'use strict';

var app = require('../..');
import request from 'supertest';

describe('Settings API:', function() {

  describe('GET /api/settings', function() {
    var settings;

    beforeEach(function(done) {
      request(app)
        .get('/api/settings/getSettings')
        .expect(200)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          settings = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(settings).to.be.instanceOf(Object);
    });

  });

});
