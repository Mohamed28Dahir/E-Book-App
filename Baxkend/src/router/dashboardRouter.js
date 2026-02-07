const express = require('express');
const router = express.Router();
const dashboardController = require('../controller/dashboardController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');

// Protected route, maybe admin only or accessible to all? Usually Admin.
router.get('/stats', [auth, role(['admin'])], dashboardController.getStats);

module.exports = router;
