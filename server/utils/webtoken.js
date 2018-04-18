var config = require('../config/environment');
var jwt = require('jsonwebtoken');

function webtoken(req, res, next) {
  var token = req.body.token || req.query.token || req.headers['x-access-token'] || req.headers.authorization;
  if (token) {
    // decode token
    jwt.verify(token, config.secret, function(err, decoded) {    
      if (err) {
        // res.redirect('/login');
        return res.status(401).send({ 
            success: false, 
            message: 'Failed to authenticate token'
        });
      } else {
        // everything ok
        req.decoded = decoded;
        next();
      }
    });

  } else {
    return res.status(401).send({ 
        success: false, 
        message: 'No token provided.' 
    });
  }
}
module.exports = webtoken;