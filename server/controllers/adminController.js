// Admin controller for user management
const admin = require('../config/firebase');

// List users
exports.listUsers = async (req, res) => {
  try {
    const usersSnap = await admin.firestore().collection('Users').limit(100).get();
    const users = usersSnap.docs.map(doc => doc.data());
    res.json(users);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Ban user (set status)
exports.banUser = async (req, res) => {
  const { userId } = req.body;
  try {
    await admin.firestore().collection('Users').doc(userId).update({ status: 'banned' });
    res.json({ message: 'User banned' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// View reports
exports.viewReports = async (req, res) => {
  try {
    const reportsSnap = await admin.firestore().collection('Reports').orderBy('createdAt', 'desc').limit(50).get();
    const reports = reportsSnap.docs.map(doc => doc.data());
    res.json(reports);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
