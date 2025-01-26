import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String location;
  final List<String> images;
  final Map<String, dynamic> amenities;
  final String ownerId;
  final bool isVerified;
  final DateTime createdAt;
  final PropertyType type;
  final PropertyStatus status;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.images,
    required this.amenities,
    required this.ownerId,
    required this.isVerified,
    required this.createdAt,
    required this.type,
    required this.status,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      location: data['location'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      amenities: data['amenities'] ?? {},
      ownerId: data['ownerId'] ?? '',
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      type: PropertyType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => PropertyType.apartment,
      ),
      status: PropertyStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => PropertyStatus.available,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'images': images,
      'amenities': amenities,
      'ownerId': ownerId,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.toString(),
      'status': status.toString(),
    };
  }
}

enum PropertyType { apartment, house, room, studio }
enum PropertyStatus { available, pending, rented }

