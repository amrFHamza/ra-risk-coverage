/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/users              ->  index
 */

'use strict';

var db = require("../../utils/db");
var jwt = require('jsonwebtoken'); 
var config = require('../../config/environment');

// Gets a list of Users
export function index(req, res) {
	db.query('SELECT * FROM AMX_USER', function (err, row) {
		if (err) {
			console.log(err);
		}
  	res.json(row);
	});
}

// Gets a list of Users
export function postApiEndpoint(req, res, next) {

  if (req.params.apiEndpoint === "login")
  db.query('select * from AMX_USER where lower(EMAIL)=lower(?) and PASSWORD=? LIMIT 1', 
    [req.body.postUser, req.body.postPassword], 
    function(err, row) {

    if(err !== null) {
      console.log(err);
      res.json({ 
          userAuth: false,
          userAuthFailed: true,
          userName: req.body.postUser,
          error: err
      });
    }
    else if (row === null || row === undefined || row.length === 0) {
      db.query('update AMX_USER set login_failed = login_failed + 1 where lower(EMAIL)=lower(?)', 
        [req.body.postUser]);
      res.json({ 
          userAuth: false,
          userAuthFailed: true,
          userName: req.body.postUser
      });
    }
    else {
    	row = row[0];
      db.query('update AMX_USER set login_success = login_success + 1 where lower(EMAIL)=lower(?)', 
        [req.body.postUser]);

      // When authenticated create token
      var token = jwt.sign({ id: row.EMAIL }, config.secret, {
        expiresIn: 86400 // expires in 24 hours
      });

      res.json({
          userAuth: true,
          userName: row.EMAIL,
          userAlias: row.USERNAME,
          userToken: token,
          userOpcoId: row.OPCO_ID,
          userAccessLevel: row.ACCESS_LEVEL
        });
    }
  });

  if (req.params.apiEndpoint === "changePassword") {
  
    db.query('update AMX_USER set PASSWORD=?, MODIfIED=CURRENT_TIMESTAMP where lower(EMAIL)=lower(?)', 
      [req.body.postPassword, req.body.postUser], 
      function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json({
            success: true
          });
      }
    });

  }

  if (req.params.apiEndpoint === "saveMessageConfig") {
  
    db.query('update AMX_USER set MESSAGE_CONFIG=? where lower(EMAIL)=lower(?)', 
      [JSON.stringify(req.body.userMessageConfig), req.body.userName], 
      function(err, row) {
      if(err !== null) {
        console.log(err);
        next(err);
      }
      else {
        res.json({
            success: true
          });
      }
    });

  }

}
