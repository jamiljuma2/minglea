// Analytics routes
const express = require('express');
const router = express.Router();
const analyticsController = require('../controllers/analyticsController');
const auth = require('../middleware/authMiddleware');
const admin = require('../middleware/adminMiddleware');

router.get('/stats', auth, admin, analyticsController.getStats);
router.get('/revenue', auth, admin, analyticsController.getRevenue);

module.exports = router;
