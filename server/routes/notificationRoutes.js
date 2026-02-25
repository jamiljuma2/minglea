// Notification routes
const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const notificationService = require('../services/notificationService');
const auth = require('../middleware/authMiddleware');

// Save FCM token
router.post('/save-fcm-token', auth, notificationController.saveFcmToken);

// Send push notification
router.post('/send', auth, async (req, res) => {
	const { token, title, body, data } = req.body;
	if (!token || !title || !body) return res.status(400).json({ error: 'Missing token, title, or body' });
	try {
		await notificationService.sendPushNotification(token, title, body, data);
		res.json({ success: true });
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

module.exports = router;
