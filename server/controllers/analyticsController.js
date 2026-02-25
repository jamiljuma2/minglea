// Analytics controller for admin dashboard
const admin = require('../config/firebase');

exports.getStats = async (req, res) => {
  try {
    const usersSnap = await admin.firestore().collection('Users').get();
    const matchesSnap = await admin.firestore().collection('Matches').get();
    const paymentsSnap = await admin.firestore().collection('Payments').get();
    const reportsSnap = await admin.firestore().collection('Reports').get();
    res.json({
      users: usersSnap.size,
      matches: matchesSnap.size,
      payments: paymentsSnap.size,
      reports: reportsSnap.size
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getRevenue = async (req, res) => {
  try {
    const paymentsSnap = await admin.firestore().collection('Payments').where('status', '==', 'success').get();
    let total = 0;
    paymentsSnap.forEach(doc => { total += doc.data().amount || 0; });
    res.json({ revenue: total });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
