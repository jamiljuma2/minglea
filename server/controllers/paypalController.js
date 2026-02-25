// PayPal payment controller
const paypalService = require('../services/paypalService');
const admin = require('../config/firebase');

// Create PayPal order
exports.createOrder = async (req, res) => {
  const userId = req.user.uid;
  const { amount, currency, returnUrl, cancelUrl } = req.body;
  try {
    const order = await paypalService.createOrder(amount, currency, returnUrl, cancelUrl);
    // Store pending payment in Firestore
    await admin.firestore().collection('Payments').add({
      userId,
      amount,
      currency,
      provider: 'paypal',
      status: 'pending',
      orderId: order.id,
      createdAt: new Date().toISOString()
    });
    res.json(order);
  } catch (err) {
    res.status(400).json({ error: err.message || err });
  }
};

// Capture PayPal order
exports.captureOrder = async (req, res) => {
  const { orderId } = req.body;
  try {
    const result = await paypalService.captureOrder(orderId);
    // Update payment status in Firestore
    const paymentsRef = admin.firestore().collection('Payments');
    const snapshot = await paymentsRef.where('orderId', '==', orderId).get();
    snapshot.forEach(doc => {
      doc.ref.update({ status: 'success', updatedAt: new Date().toISOString() });
    });
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message || err });
  }
};
