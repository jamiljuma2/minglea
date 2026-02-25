// Moderation model for Firestore (helper functions)
const admin = require('../config/firebase');

const BLOCKS_COLLECTION = 'Blocks';
const REPORTS_COLLECTION = 'Reports';

module.exports = {
  async blockUser(blockedBy, blockedUser) {
    await admin.firestore().collection(BLOCKS_COLLECTION).add({
      blockedBy,
      blockedUser,
      createdAt: new Date().toISOString()
    });
  },
  async reportUser(reportedBy, reportedUser, reason, details) {
    await admin.firestore().collection(REPORTS_COLLECTION).add({
      reportedBy,
      reportedUser,
      reason,
      details,
      createdAt: new Date().toISOString(),
      status: 'pending'
    });
  },
  async deleteUser(uid) {
    // Delete user from Auth and Firestore
    await admin.auth().deleteUser(uid);
    await admin.firestore().collection('Users').doc(uid).delete();
    await admin.firestore().collection('Profiles').doc(uid).delete();
    // Optionally: delete related data (matches, messages, etc.)
  }
};
