// Match model for Firestore (helper functions)
const admin = require('../config/firebase');

const MATCHES_COLLECTION = 'Matches';

module.exports = {
  async createMatch(userAId, userBId) {
    // Use sorted IDs for consistency
    const ids = [userAId, userBId].sort();
    const matchId = `${ids[0]}_${ids[1]}`;
    await admin.firestore().collection(MATCHES_COLLECTION).doc(matchId).set({
      userAId: ids[0],
      userBId: ids[1],
      matchedAt: new Date().toISOString(),
      isActive: true
    });
    return matchId;
  },
  async hasMatch(userAId, userBId) {
    const ids = [userAId, userBId].sort();
    const matchId = `${ids[0]}_${ids[1]}`;
    const doc = await admin.firestore().collection(MATCHES_COLLECTION).doc(matchId).get();
    return doc.exists;
  }
};
