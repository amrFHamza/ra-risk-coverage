'use strict';

var app = require('../..');
import request from 'supertest';

describe('DflDatasource API:', function() {

  describe('GET /api/dfl-datasources', function() {
    var dflDatasources;

    beforeEach(function(done) {
      request(app)
        .get('/api/dfl-datasources/getAllDatasources')
        .expect(401)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          dflDatasources = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(dflDatasources).to.be.instanceOf(Object);
    });

  });

});
