require('dotenv').config();

const express = require('express');
const cors = require('cors');
require('dotenv').config();
const app = express();

// Apply CORS middleware at the very top
app.use(cors({
  origin: [/^http:\/\/localhost:\d+$/],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));
// Handle preflight OPTIONS requests
// Removed custom app.options handler; CORS middleware handles OPTIONS requests.

app.use(express.json());

// Root route for Render and browser checks
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

// Analytics routes
const analyticsRoutes = require('./routes/analyticsRoutes');
app.use('/api/analytics', analyticsRoutes);
// Admin routes
const adminRoutes = require('./routes/adminRoutes');
app.use('/api/admin', adminRoutes);
// Monetization tricks routes
const monetizationRoutes = require('./routes/monetizationRoutes');
app.use('/api/monetization', monetizationRoutes);
// Subscription/monetization routes
const subscriptionRoutes = require('./routes/subscriptionRoutes');
app.use('/api/subscription', subscriptionRoutes);
// Notification routes
const notificationRoutes = require('./routes/notificationRoutes');
app.use('/api/notifications', notificationRoutes);
// Moderation routes
const moderationRoutes = require('./routes/moderationRoutes');
app.use('/api/moderation', moderationRoutes);
// PayPal webhook route
const paypalWebhookRoutes = require('./routes/paypalWebhookRoutes');
app.use('/', paypalWebhookRoutes);
// PayPal payment routes
const paypalRoutes = require('./routes/paypalRoutes');
app.use('/api/payments/paypal', paypalRoutes);
// Lipana webhook route
const lipanaWebhookRoutes = require('./routes/lipanaWebhookRoutes');
app.use('/', lipanaWebhookRoutes);
// Payment routes
const paymentRoutes = require('./routes/paymentRoutes');
app.use('/api/payments', paymentRoutes);
// Image upload routes
const uploadRoutes = require('./routes/uploadRoutes');
app.use('/api/upload', uploadRoutes);
// Message/chat routes
const messageRoutes = require('./routes/messageRoutes');
app.use('/api/messages', messageRoutes);
// Like/pass routes
const likeRoutes = require('./routes/likeRoutes');
app.use('/api/swipe', likeRoutes);
// Profile routes
const profileRoutes = require('./routes/profileRoutes');
app.use('/api/profile', profileRoutes);

// Health check route
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'API is running' });
});

// Auth routes
const authRoutes = require('./routes/authRoutes');
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
