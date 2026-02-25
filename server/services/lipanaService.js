// Lipana M-Pesa payment service
const axios = require('axios');

const LIPANA_BASE_URL = 'https://api.lipana.dev/v1';
const LIPANA_SECRET_KEY = process.env.LIPANA_SECRET_KEY;

exports.initiateStkPush = async (phone, amount) => {
  try {
    const response = await axios.post(
      `${LIPANA_BASE_URL}/transactions/push-stk`,
      { phone, amount },
      {
        headers: {
          'x-api-key': LIPANA_SECRET_KEY,
          'Content-Type': 'application/json'
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error.response?.data || error;
  }
};

exports.createPaymentLink = async (title, description, amount, currency, successRedirectUrl) => {
  try {
    const response = await axios.post(
      `${LIPANA_BASE_URL}/payment-links`,
      { title, description, amount, currency, allowCustomAmount: false, successRedirectUrl },
      {
        headers: {
          'x-api-key': LIPANA_SECRET_KEY,
          'Content-Type': 'application/json'
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error.response?.data || error;
  }
};
