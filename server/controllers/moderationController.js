// Moderation controller
const moderationModel = require('../models/moderationModel');

// Block user
exports.blockUser = async (req, res) => {
  const blockedBy = req.user.uid;
  const { blockedUser } = req.body;
  if (blockedBy === blockedUser) return res.status(400).json({ error: 'Cannot block yourself' });
  try {
    await moderationModel.blockUser(blockedBy, blockedUser);
    res.json({ message: 'User blocked' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Report user
exports.reportUser = async (req, res) => {
  const reportedBy = req.user.uid;
  const { reportedUser, reason, details } = req.body;
  if (reportedBy === reportedUser) return res.status(400).json({ error: 'Cannot report yourself' });
  try {
    await moderationModel.reportUser(reportedBy, reportedUser, reason, details);
    res.json({ message: 'User reported' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Delete account
exports.deleteAccount = async (req, res) => {
  const uid = req.user.uid;
  try {
    await moderationModel.deleteUser(uid);
    res.json({ message: 'Account deleted' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// AI moderation placeholder
exports.aiModeration = async (req, res) => {
  // Placeholder for AI moderation logic
  res.json({ message: 'AI moderation not implemented yet' });
};
