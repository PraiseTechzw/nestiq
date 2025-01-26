import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create booking
  Future<String> createBooking({
    required String propertyId,
    required DateTime viewingTime,
    String? notes,
  }) async {
    final currentUserId = _auth.currentUser!.uid;
    final docRef = await _firestore.collection('bookings').add({
      'propertyId': propertyId,
      'studentId': currentUserId,
      'viewingTime': Timestamp.fromDate(viewingTime),
      'status': 'pending',
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Get booking by ID
  Stream<DocumentSnapshot> getBookingById(String id) {
    return _firestore.collection('bookings').doc(id).snapshots();
  }

  // Get bookings by status
  Stream<QuerySnapshot> getBookingsByStatus(String status) {
    final userId = _auth.currentUser?.uid;
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('viewingTime')
        .snapshots();
  }

  // Get agent bookings
  Stream<QuerySnapshot> getAgentBookings() {
    final userId = _auth.currentUser?.uid;
    return _firestore
        .collection('bookings')
        .where('agentId', isEqualTo: userId)
        .orderBy('viewingTime')
        .snapshots();
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

  // Get bookings for current user
  Stream<QuerySnapshot> getUserBookings() {
    final currentUserId = _auth.currentUser!.uid;
    return _firestore
        .collection('bookings')
        .where('studentId', isEqualTo: currentUserId)
        .orderBy('viewingTime')
        .snapshots();
  }

  // Get property bookings (for agents/landlords)
  Stream<QuerySnapshot> getPropertyBookings(String propertyId) {
    return _firestore
        .collection('bookings')
        .where('propertyId', isEqualTo: propertyId)
        .orderBy('viewingTime')
        .snapshots();
  }
}

