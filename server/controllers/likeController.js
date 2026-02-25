// Like controller for like/pass actions and swipe candidates
const likeModel = require('../models/likeModel');
const matchModel = require('../models/matchModel');
const admin = require('../config/firebase');
const redis = require('../config/redis');

// Like a user
const notificationService = require('../services/notificationService');
exports.likeUser = async (req, res) => {
  const fromUserId = req.user.uid;
  const { toUserId } = req.body;
  if (fromUserId === toUserId) return res.status(400).json({ error: 'Cannot like yourself' });
  try {
    // Check if already liked
    const alreadyLiked = await likeModel.hasLiked(fromUserId, toUserId);
    if (alreadyLiked) return res.status(400).json({ error: 'Already liked' });
    await likeModel.createLike(fromUserId, toUserId);
    // Check for mutual like
    const mutual = await likeModel.hasLiked(toUserId, fromUserId);
    let matchId = null;
    if (mutual) {
      // Create match
      matchId = await matchModel.createMatch(fromUserId, toUserId);
      // Send push notification to both users
      const admin = require('../config/firebase');
      const userA = await admin.firestore().collection('Users').doc(fromUserId).get();
      const userB = await admin.firestore().collection('Users').doc(toUserId).get();
      const tokenA = userA.data().fcmToken;
      const tokenB = userB.data().fcmToken;
      if (tokenA) await notificationService.sendPushNotification(tokenA, 'It’s a Match!', 'You matched with someone!', { type: 'match' });
      if (tokenB) await notificationService.sendPushNotification(tokenB, 'It’s a Match!', 'You matched with someone!', { type: 'match' });
    }
    res.json({ message: 'User liked', mutual, matchId });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
// Fetch swipe candidates
exports.getSwipeCandidates = async (req, res) => {
  const userId = req.user.uid;
  const cacheKey = `swipe_candidates:${userId}`;
  try {
    // Try Redis cache first
    const cached = await redis.get(cacheKey);
    if (cached) {
      return res.json(JSON.parse(cached));
    }
    // Get user profile
    const userProfileDoc = await admin.firestore().collection('Profiles').doc(userId).get();
    if (!userProfileDoc.exists) return res.status(404).json({ error: 'Profile not found' });
    const userProfile = userProfileDoc.data();
    // Get all profiles except self and already swiped
    const likesSnapshot = await admin.firestore().collection('Likes')
      .where('fromUserId', '==', userId).get();
    const passedUserIds = likesSnapshot.docs.map(doc => doc.data().toUserId);
    passedUserIds.push(userId); // Exclude self
    // Filter by distance, age, interests (simple example)
    const profilesSnapshot = await admin.firestore().collection('Profiles').get();
    const candidates = [];
    profilesSnapshot.forEach(doc => {
      const p = doc.data();
      if (passedUserIds.includes(p.userId)) return;
      // Distance filter (simple, not using geohash)
      if (userProfile.location && p.location) {
        const dist = Math.sqrt(
          Math.pow(userProfile.location.lat - p.location.lat, 2) +
          Math.pow(userProfile.location.lng - p.location.lng, 2)
        );
        if (dist > 1.0) return; // Example: within ~1 degree
      }
      // Age filter
      if (p.age < (userProfile.agePrefMin || 18) || p.age > (userProfile.agePrefMax || 99)) return;
      // Shared interests
      const shared = userProfile.interests && p.interests ? userProfile.interests.filter(i => p.interests.includes(i)) : [];
      p.sharedInterests = shared.length;
      candidates.push(p);
    });
    // Sort by shared interests desc, activity score, etc.
    candidates.sort((a, b) => b.sharedInterests - a.sharedInterests);
    // Cache in Redis for 5 minutes
    await redis.set(cacheKey, JSON.stringify(candidates), 'EX', 300);
    res.json(candidates);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Pass a user (no DB write, just for analytics/future use)
exports.passUser = async (req, res) => {
  const fromUserId = req.user.uid;
  const { toUserId } = req.body;
  if (fromUserId === toUserId) return res.status(400).json({ error: 'Cannot pass yourself' });
  // Optionally log pass for analytics
  res.json({ message: 'User passed' });
};
