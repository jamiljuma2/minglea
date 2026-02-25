// Monetization tricks controller
const admin = require('../config/firebase');
const subscriptionModel = require('../models/subscriptionModel');

// Swipe limit enforcement
exports.checkSwipeLimit = async (req, res) => {
  const userId = req.user.uid;
  const today = new Date().toISOString().slice(0, 10);
  const docRef = admin.firestore().collection('SwipeCounts').doc(`${userId}_${today}`);
  const doc = await docRef.get();
  const count = doc.exists ? doc.data().count : 0;
  // Example: Free = 20, Premium = 100, Gold = unlimited
  const sub = await subscriptionModel.getSubscription(userId);
  let limit = 20;
  if (sub && sub.plan === 'premium') limit = 100;
  if (sub && sub.plan === 'gold') limit = 10000;
  res.json({ count, limit, reached: count >= limit });
};

// Increment swipe count (call after each swipe)
exports.incrementSwipeCount = async (req, res) => {
  const userId = req.user.uid;
  const today = new Date().toISOString().slice(0, 10);
  const docRef = admin.firestore().collection('SwipeCounts').doc(`${userId}_${today}`);
  await admin.firestore().runTransaction(async t => {
    const doc = await t.get(docRef);
    const count = doc.exists ? doc.data().count : 0;
    t.set(docRef, { count: count + 1, userId, date: today }, { merge: true });
  });
  res.json({ message: 'Swipe counted' });
};

// Who liked you (blurred for free users)
exports.whoLikedYou = async (req, res) => {
  const userId = req.user.uid;
  const sub = await subscriptionModel.getSubscription(userId);
  const likesSnapshot = await admin.firestore().collection('Likes')
    .where('toUserId', '==', userId).get();
  const userIds = likesSnapshot.docs.map(doc => doc.data().fromUserId);
  let users = [];
  if (userIds.length) {
    const usersSnapshot = await admin.firestore().collection('Profiles')
      .where('userId', 'in', userIds.slice(0, 10)).get();
    users = usersSnapshot.docs.map(doc => doc.data());
  }
  if (!sub || sub.plan === 'free') {
    // Blur profile info for free users
    users = users.map(u => ({ ...u, name: null, photo: null, blurred: true }));
  }
  res.json(users);
};

// Scarcity message (e.g., "3 people liked you today")
exports.scarcityMessage = async (req, res) => {
  const userId = req.user.uid;
  const today = new Date().toISOString().slice(0, 10);
  const likesSnapshot = await admin.firestore().collection('Likes')
    .where('toUserId', '==', userId)
    .where('createdAt', '>=', today).get();
  const count = likesSnapshot.size;
  // Use Unicode code point for emoji to avoid escape issues
  const fireEmoji = String.fromCodePoint(0x1F525);
  res.json({ message: `${count} people liked you today ${fireEmoji}` });
};

// Grant free boost (for referral or ad)
exports.grantFreeBoost = async (req, res) => {
  const userId = req.user.uid;
  await admin.firestore().collection('Purchases').add({
    userId,
    type: 'boost',
    amount: 0,
    source: req.body.source || 'referral',
    grantedAt: new Date().toISOString()
  });
  res.json({ message: 'Free boost granted' });
};
