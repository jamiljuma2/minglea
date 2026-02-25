// Firebase Admin SDK initialization
// If you only have the project ID, this will work if your environment has ADC (Application Default Credentials)
// For full local development, use a serviceAccountKey.json file from Firebase Console

const admin = require('firebase-admin');

admin.initializeApp({
  projectId: process.env.FIREBASE_PROJECT_ID || 'minglea-2a107', // fallback if env not set
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET || 'minglea-2a107.appspot.com'
});

module.exports = admin;
