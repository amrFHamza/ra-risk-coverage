/**
 * Main application routes
 */

'use strict';

import errors from './components/errors';
import path from 'path';
import express from 'express';

export default function(app) {

  // Insert routes below
  app.use('/api/settings', require('./api/settings'));
  app.use('/api/coverage', require('./api/coverage'));
  app.use('/api/dfl-datasources', require('./api/dflDatasource'));
  app.use('/api/dfl-procedures', require('./api/dflProcedure'));
  app.use('/api/lookups', require('./api/lookup'));
  app.use('/api/users', require('./api/user'));

  // environment information
  app.use('/api/config', function(){
      var exp = require('express');
      var router = exp.Router();
      return router.get('/', function(req, res) {   
        res.json({ 
            'env': app.get('env'),
            'NODE_ENV': process.env.NODE_ENV
        });
      });
  }());

  app.use('/images', express.static(path.join(__dirname, '../static/images')));

  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets|files)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get((req, res) => {
      res.sendFile(path.resolve(app.get('appPath') + '/index.html'));
    });
}
