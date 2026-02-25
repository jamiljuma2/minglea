// Profile model for Firestore (helper functions)
const admin = require('../config/firebase');

const PROFILES_COLLECTION = 'Profiles';

module.exports = {
  async getProfileByUserId(userId) {
    const doc = await admin.firestore().collection(PROFILES_COLLECTION).doc(userId).get();
    return doc.exists ? doc.data() : null;
  },
  async createProfile(userId, data) {
    await admin.firestore().collection(PROFILES_COLLECTION).doc(userId).set({
      ...data,
      selfieUrl: data.selfieUrl || null,
      latitude: data.latitude || null,
      longitude: data.longitude || null,
    });
  },
  async updateProfile(userId, data) {
    await admin.firestore().collection(PROFILES_COLLECTION).doc(userId).update({
      ...data,
      selfieUrl: data.selfieUrl || null,
      latitude: data.latitude || null,
      longitude: data.longitude || null,
    });
  },
  async deleteProfile(userId) {
    await admin.firestore().collection(PROFILES_COLLECTION).doc(userId).delete();
  }
};
