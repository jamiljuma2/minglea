// Monetization tricks routes
const express = require('express');
const router = express.Router();
const monetizationController = require('../controllers/monetizationController');
const auth = require('../middleware/authMiddleware');

router.get('/check-swipe-limit', auth, monetizationController.checkSwipeLimit);
router.post('/increment-swipe', auth, monetizationController.incrementSwipeCount);
router.get('/who-liked-you', auth, monetizationController.whoLikedYou);
router.get('/scarcity-message', auth, monetizationController.scarcityMessage);
router.post('/grant-free-boost', auth, monetizationController.grantFreeBoost);

module.exports = router;
