import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // TODO: Show notification in app
      debugPrint('Received notification: ${message.notification?.title}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO: Handle notification tap
      debugPrint('Notification opened: ${message.notification?.title}');
    });
    // Register FCM token with backend
    final token = await getToken();
    if (token != null) {
      await _registerTokenWithBackend(token);
    }
  }

  static Future<void> _registerTokenWithBackend(String token) async {
    // Replace with your backend API endpoint
    // TODO: Add user JWT token for auth
    // Example: Use FirebaseAuth.instance.currentUser?.getIdToken()
    try {
      await Future.delayed(
          const Duration(milliseconds: 100)); // Simulate network
      // Uncomment below for real implementation
      // final userToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      // await http.post(
      //   Uri.parse(apiUrl),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: jsonEncode({'fcmToken': token}),
      // );
      debugPrint('FCM token registered with backend: $token');
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
