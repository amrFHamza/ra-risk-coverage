'use strict';

var express = require('express');
var controller = require('./settings.controller');

var router = express.Router();

router.get('/:apiEndpoint', controller.getApiEndpoint);

module.exports = router;
