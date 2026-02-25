// Moderation routes
const express = require('express');
const router = express.Router();
const moderationController = require('../controllers/moderationController');
const auth = require('../middleware/authMiddleware');

router.post('/block', auth, moderationController.blockUser);
router.post('/report', auth, moderationController.reportUser);
router.delete('/delete-account', auth, moderationController.deleteAccount);
router.post('/ai-moderation', auth, moderationController.aiModeration);

module.exports = router;
