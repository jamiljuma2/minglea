// Authentication controller: email/password and phone OTP
const admin = require('../config/firebase');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// Helper to generate JWT
function generateToken(uid) {
  return jwt.sign({ uid }, process.env.JWT_SECRET, { expiresIn: '7d' });
}

// Email/password registration
exports.registerWithEmail = async (req, res) => {
  const { email, password } = req.body;
  try {
    const userRecord = await admin.auth().createUser({ email, password });
    const token = generateToken(userRecord.uid);
    res.status(201).json({ uid: userRecord.uid, token });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Email/password login
exports.loginWithEmail = async (req, res) => {
  const { email, password } = req.body;
  try {
    // Firebase Admin SDK does not support password verification directly
    // Use Firebase Auth REST API for signInWithPassword
    const axios = require('axios');
    const apiKey = process.env.FIREBASE_WEB_API_KEY;
    const url = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`;
    const response = await axios.post(url, { email, password, returnSecureToken: true });
    const { localId: uid } = response.data;
    const token = generateToken(uid);
    res.json({ uid, token });
  } catch (err) {
    res.status(401).json({ error: 'Invalid credentials' });
  }
};

// Phone OTP login (send code)
exports.sendPhoneOtp = async (req, res) => {
  const { phone } = req.body;
  try {
    // Use Firebase Admin to send verification code (custom implementation required)
    // Placeholder: In production, use a 3rd party SMS provider or Firebase Auth client SDK
    res.status(200).json({ message: 'OTP sent (placeholder)' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Phone OTP login (verify code)
exports.verifyPhoneOtp = async (req, res) => {
  const { phone, code } = req.body;
  try {
    // Placeholder: In production, verify OTP code
    // On success, create or get user and return JWT
    const userRecord = await admin.auth().getUserByPhoneNumber(phone);
    const token = generateToken(userRecord.uid);
    res.json({ uid: userRecord.uid, token });
  } catch (err) {
    res.status(401).json({ error: 'Invalid OTP or phone number' });
  }
};
