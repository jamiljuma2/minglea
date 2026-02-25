// Authentication routes
const express = require('express');
const router = express.Router();

const authController = require('../controllers/authController');
const validate = require('../middleware/validate');
const Joi = require('joi');

// Validation schemas
const registerSchema = Joi.object({
	email: Joi.string().email().required(),
	password: Joi.string().min(6).required()
});
const loginSchema = Joi.object({
	email: Joi.string().email().required(),
	password: Joi.string().required()
});
const phoneSchema = Joi.object({
	phone: Joi.string().required()
});
const otpSchema = Joi.object({
	phone: Joi.string().required(),
	code: Joi.string().required()
});

// Email/password
router.post('/register', validate(registerSchema), authController.registerWithEmail);
router.post('/login', validate(loginSchema), authController.loginWithEmail);

// Phone OTP
router.post('/send-otp', validate(phoneSchema), authController.sendPhoneOtp);
router.post('/verify-otp', validate(otpSchema), authController.verifyPhoneOtp);

module.exports = router;
