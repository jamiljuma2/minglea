// Profile controller for CRUD operations
const profileModel = require('../models/profileModel');

exports.createProfile = async (req, res) => {
  const userId = req.user.uid;
  const data = req.body;
  try {
    await profileModel.createProfile(userId, { ...data, userId, selfieUrl: data.selfieUrl });
    // Invalidate nearby cache
    const nearbyRoutes = require('../routes/nearbyRoutes');
    if (nearbyRoutes.invalidateNearbyCache) nearbyRoutes.invalidateNearbyCache();
    res.status(201).json({ message: 'Profile created' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getProfile = async (req, res) => {
  const userId = req.user.uid;
  try {
    const profile = await profileModel.getProfileByUserId(userId);
    if (!profile) return res.status(404).json({ error: 'Profile not found' });
    res.json(profile);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateProfile = async (req, res) => {
  const userId = req.user.uid;
  const data = req.body;
  try {
    await profileModel.updateProfile(userId, { ...data, selfieUrl: data.selfieUrl });
    // Invalidate nearby cache
    const nearbyRoutes = require('../routes/nearbyRoutes');
    if (nearbyRoutes.invalidateNearbyCache) nearbyRoutes.invalidateNearbyCache();
    res.json({ message: 'Profile updated' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteProfile = async (req, res) => {
  const userId = req.user.uid;
  try {
    await profileModel.deleteProfile(userId);
    // Invalidate nearby cache
    const nearbyRoutes = require('../routes/nearbyRoutes');
    if (nearbyRoutes.invalidateNearbyCache) nearbyRoutes.invalidateNearbyCache();
    res.json({ message: 'Profile deleted' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
