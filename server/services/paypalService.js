// PayPal payment service
const axios = require('axios');

const PAYPAL_CLIENT_ID = process.env.PAYPAL_CLIENT_ID;
const PAYPAL_CLIENT_SECRET = process.env.PAYPAL_CLIENT_SECRET;
const PAYPAL_API_BASE = process.env.PAYPAL_API_BASE || 'https://api-m.paypal.com'; // Use sandbox for testing

// Get OAuth token
async function getAccessToken() {
  const response = await axios.post(
    `${PAYPAL_API_BASE}/v1/oauth2/token`,
    'grant_type=client_credentials',
    {
      auth: {
        username: PAYPAL_CLIENT_ID,
        password: PAYPAL_CLIENT_SECRET
      },
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    }
  );
  return response.data.access_token;
}

// Create PayPal order
exports.createOrder = async (amount, currency, returnUrl, cancelUrl) => {
  const accessToken = await getAccessToken();
  const response = await axios.post(
    `${PAYPAL_API_BASE}/v2/checkout/orders`,
    {
      intent: 'CAPTURE',
      purchase_units: [{ amount: { value: amount, currency_code: currency } }],
      application_context: { return_url: returnUrl, cancel_url: cancelUrl }
    },
    { headers: { Authorization: `Bearer ${accessToken}` } }
  );
  return response.data;
};

// Capture PayPal order
exports.captureOrder = async (orderId) => {
  const accessToken = await getAccessToken();
  const response = await axios.post(
    `${PAYPAL_API_BASE}/v2/checkout/orders/${orderId}/capture`,
    {},
    { headers: { Authorization: `Bearer ${accessToken}` } }
  );
  return response.data;
};
