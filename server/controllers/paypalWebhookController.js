// PayPal webhook controller
const admin = require('../config/firebase');

exports.handleWebhook = async (req, res) => {
  try {
    const event = req.body.event_type;
    const resource = req.body.resource;
    if (event === 'CHECKOUT.ORDER.APPROVED' && resource.id) {
      // Mark payment as success in Firestore
      const paymentsRef = admin.firestore().collection('Payments');
      const snapshot = await paymentsRef.where('orderId', '==', resource.id).get();
      snapshot.forEach(doc => {
        doc.ref.update({ status: 'success', updatedAt: new Date().toISOString() });
      });
    }
    if (event === 'PAYMENT.CAPTURE.DENIED' && resource.id) {
      const paymentsRef = admin.firestore().collection('Payments');
      const snapshot = await paymentsRef.where('orderId', '==', resource.id).get();
      snapshot.forEach(doc => {
        doc.ref.update({ status: 'failed', updatedAt: new Date().toISOString() });
      });
    }
    res.status(200).json({ received: true });
  } catch (err) {
    res.status(500).send('Internal Server Error');
  }
};
