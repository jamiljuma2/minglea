// Subscription model for Firestore (helper functions)
const admin = require('../config/firebase');

const SUBSCRIPTIONS_COLLECTION = 'Subscriptions';

module.exports = {
  async setSubscription(userId, plan, expiresAt) {
    await admin.firestore().collection(SUBSCRIPTIONS_COLLECTION).doc(userId).set({
      userId,
      plan,
      expiresAt,
      updatedAt: new Date().toISOString()
    });
  },
  async getSubscription(userId) {
    const doc = await admin.firestore().collection(SUBSCRIPTIONS_COLLECTION).doc(userId).get();
    return doc.exists ? doc.data() : null;
  },
  async purchaseBoost(userId, type, amount) {
    await admin.firestore().collection('Purchases').add({
      userId,
      type, // 'boost', 'superlike', 'spotlight'
      amount,
      purchasedAt: new Date().toISOString()
    });
  }
};
