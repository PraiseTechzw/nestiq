import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create payment intent (Stripe)
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String propertyId,
  }) async {
    try {
      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call({
        'amount': (amount * 100).round(), // Convert to cents
        'currency': currency,
        'propertyId': propertyId,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  // Process PayNow payment
  Future<Map<String, dynamic>> processPayNowPayment({
    required double amount,
    required String propertyId,
    required String phoneNumber,
  }) async {
    try {
      final callable = _functions.httpsCallable('processPayNowPayment');
      final result = await callable.call({
        'amount': amount,
        'propertyId': propertyId,
        'phoneNumber': phoneNumber,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to process PayNow payment: $e');
    }
  }

  // Save payment record
  Future<void> savePaymentRecord({
    required String propertyId,
    required String userId,
    required double amount,
    required String paymentMethod,
    required String status,
    String? transactionId,
  }) async {
    await _firestore.collection('payments').add({
      'propertyId': propertyId,
      'userId': userId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get payment history
  Stream<QuerySnapshot> getPaymentHistory(String userId) {
    return _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

