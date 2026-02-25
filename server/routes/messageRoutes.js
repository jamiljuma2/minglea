
const express = require('express');
const router = express.Router();
const messageController = require('../controllers/messageController');
const auth = require('../middleware/authMiddleware');
// Typing indicator placeholder
router.post('/typing', auth, messageController.setTyping);


// All routes protected by JWT
router.post('/send', auth, messageController.sendMessage);
router.get('/:matchId', auth, messageController.getMessages);
router.post('/seen', auth, messageController.markAsSeen);

module.exports = router;
