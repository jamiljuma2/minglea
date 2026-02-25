// User model for Firestore (helper functions)
const admin = require('../config/firebase');

const USERS_COLLECTION = 'Users';

module.exports = {
  async getUserById(uid) {
    const doc = await admin.firestore().collection(USERS_COLLECTION).doc(uid).get();
    return doc.exists ? doc.data() : null;
  },
  async createUser(uid, data) {
    await admin.firestore().collection(USERS_COLLECTION).doc(uid).set(data);
  },
  async updateUser(uid, data) {
    await admin.firestore().collection(USERS_COLLECTION).doc(uid).update(data);
  },
  async deleteUser(uid) {
    await admin.firestore().collection(USERS_COLLECTION).doc(uid).delete();
  }
};
