import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Verify property
  Future<void> verifyProperty(String propertyId, bool isVerified) async {
    await _firestore.collection('properties').doc(propertyId).update({
      'isVerified': isVerified,
      'verifiedAt': isVerified ? FieldValue.serverTimestamp() : null,
    });
  }

  // Verify user (agent/landlord)
  Future<void> verifyUser(String userId, bool isVerified) async {
    await _firestore.collection('users').doc(userId).update({
      'isVerified': isVerified,
      'verifiedAt': isVerified ? FieldValue.serverTimestamp() : null,
    });
  }

  // Get unverified properties
  Stream<QuerySnapshot> getUnverifiedProperties() {
    return _firestore
        .collection('properties')
        .where('isVerified', isEqualTo: false)
        .snapshots();
  }

  // Get unverified users
  Stream<QuerySnapshot> getUnverifiedUsers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'UserRole.agent')
        .where('isVerified', isEqualTo: false)
        .snapshots();
  }

  // Get users
  Stream<QuerySnapshot> getUsers({String? role}) {
    Query query = _firestore.collection('users');
    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    return query.snapshots();
  }

  // Get properties
  Stream<QuerySnapshot> getProperties({String? status}) {
    Query query = _firestore.collection('properties');
    if (status != null) {
      query = query.where('isVerified', isEqualTo: status == 'verified');
    }
    return query.snapshots();
  }

  // Get reviews
  Stream<QuerySnapshot> getReviews() {
    return _firestore
        .collectionGroup('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    // Note: This requires a collection group query to find the review
    final reviews = await _firestore
        .collectionGroup('reviews')
        .where(FieldPath.documentId, isEqualTo: reviewId)
        .get();

    if (reviews.docs.isNotEmpty) {
      await reviews.docs.first.reference.delete();
    }
  }

  // Get analytics data
  Future<Map<String, dynamic>> getAnalytics() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final propertiesQuery = await _firestore
        .collection('properties')
        .where('createdAt', isGreaterThan: thirtyDaysAgo)
        .get();

    final bookingsQuery = await _firestore
        .collection('bookings')
        .where('createdAt', isGreaterThan: thirtyDaysAgo)
        .get();

    final paymentsQuery = await _firestore
        .collection('payments')
        .where('timestamp', isGreaterThan: thirtyDaysAgo)
        .get();

    return {
      'totalProperties': propertiesQuery.size,
      'totalBookings': bookingsQuery.size,
      'totalPayments': paymentsQuery.docs
          .fold(0.0, (sum, doc) => sum + (doc.data()['amount'] as num)),
    };
  }
}

