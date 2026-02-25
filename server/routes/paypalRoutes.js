// PayPal payment routes
const express = require('express');
const router = express.Router();
const paypalController = require('../controllers/paypalController');
const auth = require('../middleware/authMiddleware');

// Create PayPal order
router.post('/create-order', auth, paypalController.createOrder);
// Capture PayPal order
router.post('/capture-order', auth, paypalController.captureOrder);

module.exports = router;
