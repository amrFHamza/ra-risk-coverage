'use strict';

var app = require('../..');
import request from 'supertest';

describe('DflProcedure API:', function() {

  describe('GET /api/dfl-procedures', function() {
    var dflProcedures;

    beforeEach(function(done) {
      request(app)
        .get('/api/dfl-procedures/getAllProcedures')
        .expect(401)
        .expect('Content-Type', /json/)
        .end((err, res) => {
          if (err) {
            return done(err);
          }
          dflProcedures = res.body;
          done();
        });
    });

    it('should respond with JSON array', function() {
      expect(dflProcedures).to.be.instanceOf(Object);
    });

  });

});
