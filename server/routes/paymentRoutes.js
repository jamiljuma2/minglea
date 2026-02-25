// Payment routes for M-Pesa LIPANA
const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const auth = require('../middleware/authMiddleware');

// Initiate STK Push
router.post('/mpesa/stk-push', auth, paymentController.initiateStkPush);

// Create Payment Link (optional)
router.post('/mpesa/payment-link', auth, paymentController.createPaymentLink);

module.exports = router;
