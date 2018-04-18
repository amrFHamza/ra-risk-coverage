var mysql      = require('mysql');

/*
	IMPORTANT: Set your DB configuration and
	rename this file to "db.js"
	Note: db.js is in .gitignore 
*/

var pool  = mysql.createPool({
  connectionLimit : 10,
  host     				: 'localhost',
  database 				: 'tag',
  user     				: 'user',
  password 				: 'password'
});

module.exports = pool;
