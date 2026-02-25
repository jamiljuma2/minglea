// Lipana webhook controller
const crypto = require('crypto');
const admin = require('../config/firebase');

// Helper to verify Lipana webhook signature
function verifySignature(rawBody, signature) {
  const secret = process.env.LIPANA_WEBHOOK_SECRET;
  const expected = crypto.createHmac('sha256', secret).update(rawBody).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expected));
}

exports.handleWebhook = async (req, res) => {
  try {
    const signature = req.headers['x-lipana-signature'];
    if (!signature) return res.status(401).send('Unauthorized');
    const rawBody = req.body.toString();
    if (!verifySignature(rawBody, signature)) return res.status(401).send('Unauthorized');
    const data = JSON.parse(rawBody);
    const { event, data: eventData } = data;
    // Process payment events
    if (event === 'payment.success' && eventData.transactionId) {
      // Update payment status in Firestore
      const paymentsRef = admin.firestore().collection('Payments');
      const snapshot = await paymentsRef.where('transactionId', '==', eventData.transactionId).get();
      snapshot.forEach(doc => {
        doc.ref.update({ status: 'success', updatedAt: new Date().toISOString() });
      });
    }
    if (event === 'payment.failed' && eventData.transactionId) {
      const paymentsRef = admin.firestore().collection('Payments');
      const snapshot = await paymentsRef.where('transactionId', '==', eventData.transactionId).get();
      snapshot.forEach(doc => {
        doc.ref.update({ status: 'failed', updatedAt: new Date().toISOString() });
      });
    }
    res.status(200).json({ received: true });
  } catch (err) {
    res.status(500).send('Internal Server Error');
  }
};
