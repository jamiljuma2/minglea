// Nearby user search route
const express = require('express');
const router = express.Router();
const admin = require('../config/firebase');
const auth = require('../middleware/authMiddleware');
const redis = require('redis');
const client = redis.createClient();

// GET /api/nearby?lat=...&lng=...&radius=km
router.get('/', auth, async (req, res) => {
  const { lat, lng, radius, gender, interests, minAge, maxAge, online, sort } = req.query;
  if (!lat || !lng || !radius) return res.status(400).json({ error: 'Missing lat, lng, or radius' });
  const cacheKey = 'nearby:' + Object.entries(req.query).map(([k, v]) => `${k}=${v}`).join('&');
  try {
    client.get(cacheKey, async (err, cached) => {
      if (cached) {
        return res.json(JSON.parse(cached));
      }
      // Calculate bounding box for radius
      const R = 6371; // Earth radius in km
      const latNum = parseFloat(lat);
      const lngNum = parseFloat(lng);
      const radiusNum = parseFloat(radius);
      const latDelta = radiusNum / R * (180 / Math.PI);
      const lngDelta = radiusNum / (R * Math.cos(latNum * Math.PI / 180)) * (180 / Math.PI);
      const minLat = latNum - latDelta;
      const maxLat = latNum + latDelta;
      const minLng = lngNum - lngDelta;
      const maxLng = lngNum + lngDelta;
      let query = admin.firestore().collection('Profiles')
        .where('latitude', '>=', minLat)
        .where('latitude', '<=', maxLat)
        .where('longitude', '>=', minLng)
        .where('longitude', '<=', maxLng);
      const snapshot = await query.get();
      let users = [];
      snapshot.forEach(doc => {
        const data = doc.data();
        if (data.latitude && data.longitude) {
          // Haversine formula
          const toRad = x => x * Math.PI / 180;
          const dLat = toRad(data.latitude - latNum);
          const dLng = toRad(data.longitude - lngNum);
          const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                    Math.cos(toRad(latNum)) * Math.cos(toRad(data.latitude)) *
                    Math.sin(dLng/2) * Math.sin(dLng/2);
          const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
          const distance = R * c;
          if (distance <= radiusNum) {
            users.push({ ...data, distance });
          }
        }
      });
      // Filters
      if (gender) {
        users = users.filter(u => u.gender === gender);
      }
      if (interests) {
        const interestArr = Array.isArray(interests) ? interests : interests.split(',');
        users = users.filter(u => u.interests && interestArr.some(i => u.interests.includes(i)));
      }
      if (minAge || maxAge) {
        users = users.filter(u => {
          const age = u.age || 0;
          return (!minAge || age >= parseInt(minAge)) && (!maxAge || age <= parseInt(maxAge));
        });
      }
      if (online === 'true') {
        users = users.filter(u => u.online === true);
      }
      // Sorting
      if (sort === 'distance') {
        users.sort((a, b) => (a.distance || 0) - (b.distance || 0));
      } else if (sort === 'age') {
        users.sort((a, b) => (a.age || 0) - (b.age || 0));
      } else if (sort === 'lastActive') {
        users.sort((a, b) => new Date(b.lastActive || 0) - new Date(a.lastActive || 0));
      }
      // Cache result for 1 minute
      client.setex(cacheKey, 60, JSON.stringify(users));
      res.json(users);
      // Cache invalidation utility
      function invalidateNearbyCache() {
        client.keys('nearby:*', (err, keys) => {
          if (keys && keys.length > 0) {
            client.del(keys);
          }
        });
      }
      res.json(users);
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
