// Notification service using Firebase Cloud Messaging
const admin = require('../config/firebase');

exports.sendPushNotification = async (token, title, body, data = {}) => {
  const message = {
    token,
    notification: { title, body },
    data
  };
  await admin.messaging().send(message);
};
