// OAuth routes for Instagram and Facebook
const express = require('express');
const router = express.Router();
const oauthController = require('../controllers/oauthController');
const auth = require('../middleware/authMiddleware');

router.get('/instagram/callback', auth, oauthController.instagramOAuthCallback);
router.get('/facebook/callback', auth, oauthController.facebookOAuthCallback);

module.exports = router;
