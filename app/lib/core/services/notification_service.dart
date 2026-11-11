import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging — best-effort setup. Token registration is
/// attempted after login; failures never block the app (e.g. no Firebase
/// config in demo mode).
class NotificationService {
  String? token;

  /// Latest known FCM token, readable without an instance so app state
  /// can register it with the backend once a user is signed in.
  static String? lastToken;

  Future<void> initialize() async {
    try {
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      token = await fm.getToken();
      lastToken = token;
      fm.onTokenRefresh.listen((t) {
        token = t;
        lastToken = t;
      });
      FirebaseMessaging.onMessage.listen((msg) {
        debugPrint('FCM foreground: ${msg.notification?.title}');
      });
    } catch (e) {
      debugPrint('FCM init skipped: $e');
    }
  }
}
