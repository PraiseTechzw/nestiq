import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Initialize notifications
  Future<void> initialize() async {
    // Request permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final token = await _fcm.getToken();
    if (token != null) {
      await _saveToken(token);
    }

    // Listen to token refresh
    _fcm.onTokenRefresh.listen(_saveToken);

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // Save FCM token to Firestore
  Future<void> _saveToken(String token) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _firestore.collection('users').doc(currentUserId).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    }
  }

  // Handle incoming message
  void _handleMessage(RemoteMessage message) {
    // Handle the message based on your app's needs
    print('Received message: ${message.data}');
  }

  // Send notification
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _functions.httpsCallable('sendNotification').call({
        'userId': userId,
        'title': title,
        'body': body,
        'data': data,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

