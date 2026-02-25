// Subscription and monetization controller
const subscriptionModel = require('../models/subscriptionModel');

// Set or update subscription
exports.setSubscription = async (req, res) => {
  const userId = req.user.uid;
  const { plan, expiresAt } = req.body;
  try {
    await subscriptionModel.setSubscription(userId, plan, expiresAt);
    res.json({ message: 'Subscription updated' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Get subscription
exports.getSubscription = async (req, res) => {
  const userId = req.user.uid;
  try {
    const sub = await subscriptionModel.getSubscription(userId);
    res.json(sub);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Purchase boost/superlike/spotlight
exports.purchase = async (req, res) => {
  const userId = req.user.uid;
  const { type, amount } = req.body;
  try {
    await subscriptionModel.purchaseBoost(userId, type, amount);
    res.json({ message: 'Purchase successful' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
