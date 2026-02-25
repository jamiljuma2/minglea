// Lipana webhook route
const express = require('express');
const router = express.Router();
const lipanaWebhookController = require('../controllers/lipanaWebhookController');

// Use express.raw to get raw body for signature verification
router.post('/webhook/lipana', express.raw({ type: 'application/json' }), lipanaWebhookController.handleWebhook);

module.exports = router;
