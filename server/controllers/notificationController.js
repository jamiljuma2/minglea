// Notification controller
const admin = require('../config/firebase');

// Save FCM token for user
exports.saveFcmToken = async (req, res) => {
  const userId = req.user.uid;
  const { fcmToken } = req.body;
  try {
    await admin.firestore().collection('Users').doc(userId).update({ fcmToken });
    res.json({ message: 'FCM token saved' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
