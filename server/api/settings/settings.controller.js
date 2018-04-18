/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/settingss              ->  index
 */

'use strict';

var db = require("../../utils/db");
var _und = require("underscore");
var async = require("async");

// CREATE SCHEMA `tag` DEFAULT CHARACTER SET utf8 ;

export function getApiEndpoint(req, res, next) {

  if (req.params.apiEndpoint === "getSettings") { 
    db.query("select 1", function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json(row);
      }
    });
  }
  else if (req.params.apiEndpoint === "importRiskCatalogue") {
    if (req.query.riskCatalogue === 'TMF') {

      var terminal = require('child_process').spawn('mysql', [
          '-u' + db.config.connectionConfig.user,
          '-p' + db.config.connectionConfig.password,
          '-h' + db.config.connectionConfig.host,
          '--default-character-set=utf8'
      ]);

      terminal.stdin.write( '\\. ' + 'server/db/rrc_tmf.sql' );
      terminal.stdin.end();

      terminal.stdout.on('data', function (data) {
        console.log('stdout: ' + data);
      });

      terminal.stderr.on('data', function(data){
        console.log('stderr:' + data);
      });

      terminal.on('exit', function (code) {
        console.log('Finished.');
        res.json({success: true});
      });
    }
    else if (req.query.riskCatalogue === 'RAG') {

      var terminal = require('child_process').spawn('mysql', [
          '-u' + db.config.connectionConfig.user,
          '-p' + db.config.connectionConfig.password,
          '-h' + db.config.connectionConfig.host,
          '--default-character-set=utf8'
      ]);

      terminal.stdin.write( '\\. ' + 'server/db/rrc_rag.sql' );
      terminal.stdin.end();

      terminal.stdout.on('data', function (data) {
        console.log('stdout: ' + data);
      });

      terminal.stderr.on('data', function(data){
        console.log('stderr:' + data);
      });

      terminal.on('exit', function (code) {
        console.log('Finished.');
        res.json({success: true});
      });
    } 
    else if (req.query.riskCatalogue === 'A1TA') {

      var terminal = require('child_process').spawn('mysql', [
          '-u' + db.config.connectionConfig.user,
          '-p' + db.config.connectionConfig.password,
          '-h' + db.config.connectionConfig.host,
          '--default-character-set=utf8'
      ]);

      terminal.stdin.write( '\\. ' + 'server/db/rrc_a1.sql' );
      terminal.stdin.end();

      terminal.stdout.on('data', function (data) {
        console.log('stdout: ' + data);
      });

      terminal.stderr.on('data', function(data){
        console.log('stderr:' + data);
      });

      terminal.on('exit', function (code) {
        console.log('Finished.');
        res.json({success: true});
      });
    }    
    else {
        res.json({success: true});
    }

  }
}