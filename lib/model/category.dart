import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Function to upload accommodation categories to Firestore
Future<void> saveCategoryItems() async {
  final CollectionReference ref = 
      FirebaseFirestore.instance.collection("StudentAccommodationCategories");

  for (final Category category in categoriesList) {
    final String id = const Uuid().v4(); // Generate a unique ID
    await ref.doc(id).set(category.toMap());
  }
}

class Category {
  final String title;
  final IconData icon; // Use IconData instead of an image URL

  Category({
    required this.title,
    required this.icon,
  });

  // Convert to a map for Firestore (store the icon as a string)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon.codePoint, // Store icon code point
    };
  }
}

// Student Accommodation Categories
final List<Category> categoriesList = [
  Category(title: "Private Rooms", icon: Icons.single_bed),
  Category(title: "Shared Rooms", icon: Icons.bed),
  Category(title: "Full Apartments", icon: Icons.apartment),
  Category(title: "Boarding Houses", icon: Icons.house),
  Category(title: "Studio Apartments", icon: Icons.domain),
  Category(title: "Girls-Only Housing", icon: Icons.female),
  Category(title: "Boys-Only Housing", icon: Icons.male),
  Category(title: "Luxury Student Living", icon: Icons.star),
  Category(title: "Budget-Friendly", icon: Icons.money_off),
  Category(title: "Close to Campus", icon: Icons.location_on),
  Category(title: "Wi-Fi Included", icon: Icons.wifi),
  Category(title: "Self-Catering Units", icon: Icons.kitchen),
  Category(title: "Furnished Spaces", icon: Icons.chair),
  Category(title: "Verified Listings", icon: Icons.verified),
  Category(title: "Short-Term Stays", icon: Icons.hourglass_top),
];

// Function to retrieve the icon in Flutter (from Firestore)
IconData getIconFromCodePoint(int codePoint) {
  return IconData(codePoint, fontFamily: 'MaterialIcons');
}
