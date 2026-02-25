// OAuth controller for Instagram and Facebook
const axios = require('axios');
const profileModel = require('../models/profileModel');

exports.instagramOAuthCallback = async (req, res) => {
  const { code } = req.query;
  const userId = req.user.uid;
  try {
    // Exchange code for access token (Instagram)
    // Replace with your Instagram App credentials
    const tokenRes = await axios.post('https://api.instagram.com/oauth/access_token', {
      client_id: process.env.INSTAGRAM_CLIENT_ID,
      client_secret: process.env.INSTAGRAM_CLIENT_SECRET,
      grant_type: 'authorization_code',
      redirect_uri: process.env.INSTAGRAM_REDIRECT_URI,
      code,
    });
    const accessToken = tokenRes.data.access_token;
    // Mark user as verified in Firestore
    await profileModel.updateProfile(userId, { instagramVerified: true });
    res.json({ verified: true });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.facebookOAuthCallback = async (req, res) => {
  const { code } = req.query;
  const userId = req.user.uid;
  try {
    // Exchange code for access token (Facebook)
    // Replace with your Facebook App credentials
    const tokenRes = await axios.get('https://graph.facebook.com/v10.0/oauth/access_token', {
      params: {
        client_id: process.env.FACEBOOK_CLIENT_ID,
        client_secret: process.env.FACEBOOK_CLIENT_SECRET,
        redirect_uri: process.env.FACEBOOK_REDIRECT_URI,
        code,
      },
    });
    const accessToken = tokenRes.data.access_token;
    // Mark user as verified in Firestore
    await profileModel.updateProfile(userId, { facebookVerified: true });
    res.json({ verified: true });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
