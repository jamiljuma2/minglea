// Message model for Firestore (helper functions)
const admin = require('../config/firebase');

const MESSAGES_COLLECTION = 'Messages';

module.exports = {
  async sendMessage(matchId, fromUserId, toUserId, message, type = 'text', imageUrl = null) {
    const docRef = await admin.firestore().collection(MESSAGES_COLLECTION).add({
      matchId,
      fromUserId,
      toUserId,
      message,
      type,
      imageUrl,
      createdAt: new Date().toISOString(),
      seen: false
    });
    return docRef.id;
  },
  async getMessages(matchId, limit = 50) {
    const snapshot = await admin.firestore().collection(MESSAGES_COLLECTION)
      .where('matchId', '==', matchId)
      .orderBy('createdAt', 'desc')
      .limit(limit)
      .get();
    return snapshot.docs.map(doc => doc.data());
  }
};
