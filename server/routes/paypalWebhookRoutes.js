// PayPal webhook route
const express = require('express');
const router = express.Router();
const paypalWebhookController = require('../controllers/paypalWebhookController');

router.post('/webhook/paypal', express.json({ type: 'application/json' }), paypalWebhookController.handleWebhook);

module.exports = router;
