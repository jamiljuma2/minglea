// Subscription and monetization routes
const express = require('express');
const router = express.Router();
const subscriptionController = require('../controllers/subscriptionController');
const auth = require('../middleware/authMiddleware');

router.post('/set', auth, subscriptionController.setSubscription);
router.get('/get', auth, subscriptionController.getSubscription);
router.post('/purchase', auth, subscriptionController.purchase);

module.exports = router;
