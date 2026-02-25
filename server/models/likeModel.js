// Like model for Firestore (helper functions)
const admin = require('../config/firebase');

const LIKES_COLLECTION = 'Likes';

module.exports = {
  async createLike(fromUserId, toUserId) {
    const docRef = await admin.firestore().collection(LIKES_COLLECTION).add({
      fromUserId,
      toUserId,
      createdAt: new Date().toISOString()
    });
    return docRef.id;
  },
  async hasLiked(fromUserId, toUserId) {
    const snapshot = await admin.firestore().collection(LIKES_COLLECTION)
      .where('fromUserId', '==', fromUserId)
      .where('toUserId', '==', toUserId)
      .get();
    return !snapshot.empty;
  }
};
