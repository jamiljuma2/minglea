// Typing indicator placeholder (for real-time, use Firestore or WebSocket in production)
exports.setTyping = async (req, res) => {
  // In production, this would update a Firestore doc or use WebSocket
  // Here, just return success as a placeholder
  res.json({ message: 'Typing status set (placeholder)' });
};
// Mark messages as seen (read receipts)
exports.markAsSeen = async (req, res) => {
  const userId = req.user.uid;
  const { matchId } = req.body;
  try {
    // Update all messages in this match where toUserId == userId and seen == false
    const admin = require('../config/firebase');
    const snapshot = await admin.firestore().collection('Messages')
      .where('matchId', '==', matchId)
      .where('toUserId', '==', userId)
      .where('seen', '==', false)
      .get();
    const batch = admin.firestore().batch();
    snapshot.forEach(doc => {
      batch.update(doc.ref, { seen: true });
    });
    await batch.commit();
    res.json({ message: 'Messages marked as seen', count: snapshot.size });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
// Message controller for chat
const messageModel = require('../models/messageModel');
const matchModel = require('../models/matchModel');

// Send a message (text or image)
const notificationService = require('../services/notificationService');
exports.sendMessage = async (req, res) => {
  const fromUserId = req.user.uid;
  const { matchId, toUserId, message, type, imageUrl } = req.body;
  try {
    // Only allow if users are matched
    const isMatched = await matchModel.hasMatch(fromUserId, toUserId);
    if (!isMatched) return res.status(403).json({ error: 'Not matched' });
    const msgId = await messageModel.sendMessage(matchId, fromUserId, toUserId, message, type, imageUrl);
    // Send push notification to recipient
    const admin = require('../config/firebase');
    const recipient = await admin.firestore().collection('Users').doc(toUserId).get();
    const token = recipient.data().fcmToken;
    if (token) {
      await notificationService.sendPushNotification(token, 'New Message', message || 'You have a new message!', { type: 'message', fromUserId });
    }
    res.status(201).json({ message: 'Message sent', msgId });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Fetch messages for a match
exports.getMessages = async (req, res) => {
  const { matchId } = req.params;
  try {
    const messages = await messageModel.getMessages(matchId);
    res.json(messages);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
