// Payment controller for M-Pesa LIPANA
const lipanaService = require('../services/lipanaService');
const admin = require('../config/firebase');

// Initiate STK Push
exports.initiateStkPush = async (req, res) => {
  const userId = req.user.uid;
  const { phone, amount } = req.body;
  try {
    const result = await lipanaService.initiateStkPush(phone, amount);
    // Store pending payment in Firestore
    await admin.firestore().collection('Payments').add({
      userId,
      phone,
      amount,
      provider: 'mpesa',
      status: 'pending',
      transactionId: result.data?.transactionId,
      checkoutRequestID: result.data?.checkoutRequestID,
      createdAt: new Date().toISOString()
    });
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message || err });
  }
};

// Create Payment Link (optional)
exports.createPaymentLink = async (req, res) => {
  const { title, description, amount, currency, successRedirectUrl } = req.body;
  try {
    const result = await lipanaService.createPaymentLink(title, description, amount, currency, successRedirectUrl);
    res.json(result);
  } catch (err) {
    res.status(400).json({ error: err.message || err });
  }
};
