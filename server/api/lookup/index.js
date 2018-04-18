'use strict';

var express = require('express');
var controller = require('./lookup.controller');

var router = express.Router();
var webtoken = require("../../utils/webtoken");

router.get('/', controller.index);
router.get('/:apiEndpoint', controller.getApiEndpoint);
router.post('/:apiEndpoint/:table', webtoken, controller.postApiEndpoint);
router.delete('/:table', webtoken, controller.deleteIdFromTable);

module.exports = router;
