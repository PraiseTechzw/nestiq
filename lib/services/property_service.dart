import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nestiq/models/property.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get properties with filters
  Stream<QuerySnapshot> getProperties({
    PropertyType? type,
    double? minPrice,
    double? maxPrice,
    String? location,
  }) {
    Query query = _firestore.collection('properties');

    if (type != null) {
      query = query.where('type', isEqualTo: type.toString());
    }

    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }

    return query.snapshots();
  }

  // Add property
  Future<void> addProperty(Property property, List<XFile> images) async {
    try {
      // Upload images first
      final List<String> imageUrls = [];
      for (var image in images) {
        final ref = _storage.ref().child(
            'properties/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
        final uploadTask = ref.putFile(File(image.path));
        final snapshot = await uploadTask;
        final url = await snapshot.ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Create property with current user as owner
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final propertyData = property.toFirestore();
      propertyData['ownerId'] = userId;
      propertyData['images'] = imageUrls;
      propertyData['createdAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('properties').add(propertyData);
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  // Get property by ID
  Stream<DocumentSnapshot> getPropertyById(String id) {
    return _firestore.collection('properties').doc(id).snapshots();
  }

  // Get saved properties
  Stream<QuerySnapshot> getSavedProperties() {
    final userId = _auth.currentUser?.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('savedProperties')
        .snapshots();
  }

  // Get recommended properties
  Stream<QuerySnapshot> getRecommendedProperties() {
    return _firestore
        .collection('properties')
        .where('isVerified', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  // Get agent properties
  Stream<QuerySnapshot> getAgentProperties() {
    final userId = _auth.currentUser?.uid;
    return _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: userId)
        .snapshots();
  }

  // Toggle save property
  Future<bool> toggleSaveProperty(String propertyId) async {
    final userId = _auth.currentUser?.uid;
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('savedProperties')
        .doc(propertyId);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      return false;
    } else {
      await docRef.set({
        'savedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }

  // Get property reviews
  Stream<QuerySnapshot> getPropertyReviews(String propertyId) {
    return _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Add review
  Future<void> addReview({
    required String propertyId,
    required double rating,
    required String comment,
  }) async {
    final userId = _auth.currentUser?.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();

    await _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('reviews')
        .add({
      'userId': userId,
      'userName': userDoc.data()?['fullName'],
      'userPhoto': userDoc.data()?['photoUrl'],
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update property average rating
    final reviews = await _firestore
        .collection('properties')
        .doc(propertyId)
        .collection('reviews')
        .get();

    final totalRating = reviews.docs.fold<double>(
      0,
      (sum, doc) => sum + (doc.data()['rating'] as double),
    );

    await _firestore.collection('properties').doc(propertyId).update({
      'averageRating': totalRating / reviews.docs.length,
      'reviewCount': reviews.docs.length,
    });
  }
}

