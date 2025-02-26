import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveAccommodationsToFirebase() async {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("studentAccommodationsListings");
  for (final Accommodation accommodation in listOfAccommodations) {
    final String id =
        DateTime.now().toIso8601String() + Random().nextInt(1000).toString();
    await ref.doc(id).set(accommodation.toMap());
  }
}

class Accommodation {
  final String title;
  final String image;
  final double rating;
  final int price;
  final String address;
  final int review;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final String category;
  final List<String> amenities;
  final double distanceFromCampus;
  final String bedAndBathroom;
  final String university;
  final String city;
  final String agentId;
  final String agentName;
  final String agentProfilePic;
  final bool isVerified;
  final bool isAvailable;
  final String description;

  Accommodation({
    required this.title,
    required this.image,
    required this.rating,
    required this.price,
    required this.address,
    required this.review,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.category,
    required this.amenities,
    required this.distanceFromCampus,
    required this.bedAndBathroom,
    required this.university,
    required this.city,
    required this.agentId,
    required this.agentName,
    required this.agentProfilePic,
    required this.isVerified,
    required this.isAvailable,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'rating': rating,
      'price': price,
      'address': address,
      'review': review,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'category': category,
      'amenities': amenities,
      'distanceFromCampus': distanceFromCampus,
      'bedAndBathroom': bedAndBathroom,
      'university': university,
      'city': city,
      'agentId': agentId,
      'agentName': agentName,
      'agentProfilePic': agentProfilePic,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'description': description,
    };
  }
}

final List<Accommodation> listOfAccommodations = [
  Accommodation(
    title: "Cozy Private Room near UZ",
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    rating: 4.85,
    review: 126,
    price: 150,
    address: "123 University Ave, Mount Pleasant, Harare",
    latitude: -17.7829,
    longitude: 31.0530,
    imageUrls: [
      "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
      "https://media.timeout.com/images/105162711/image.jpg",
      "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
      "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    ],
    category: "Private Rooms",
    amenities: ["Wi-Fi Included", "Furnished Spaces", "Laundry Facilities"],
    distanceFromCampus: 0.5,
    bedAndBathroom: "1 bed . Shared bathroom",
    university: "University of Zimbabwe",
    city: "Harare",
    agentId: "agent001",
    agentName: "John Moyo",
    agentProfilePic: "https://example.com/john_moyo_profile.jpg",
    isVerified: true,
    isAvailable: true,
    description: "A comfortable private room perfect for UZ students. Close to campus with all necessary amenities.",
  ),
  Accommodation(
    title: "Affordable Shared Room for UZ Students",
    image:
        "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
    rating: 4.55,
    review: 26,
    price: 80,
    address: "456 College St, Belvedere, Harare",
    latitude: -17.8252,
    longitude: 31.0335,
    imageUrls: [
      "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/de/f7/c3/standard-room.jpg?w=1200&h=-1&s=1",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuMkI1MoQDzLBF-prjIp6kyXpccVol16bsew&s"
    ],
    category: "Shared Rooms",
    amenities: ["Wi-Fi Included", "Budget-Friendly", "Communal Kitchen"],
    distanceFromCampus: 1.2,
    bedAndBathroom: "2 beds . Shared bathroom",
    university: "University of Zimbabwe",
    city: "Harare",
    agentId: "agent002",
    agentName: "Sarah Ndlovu",
    agentProfilePic: "https://example.com/sarah_ndlovu_profile.jpg",
    isVerified: true,
    isAvailable: true,
    description: "An economical option for UZ students looking to share accommodation. Great for those on a tight budget.",
  ),
  Accommodation(
    title: "Modern Full Apartment for UZ Student Group",
    image: "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    rating: 4.77,
    price: 300,
    address: "789 Grad School Lane, Avondale, Harare",
    review: 160,
    latitude: -17.8019,
    longitude: 31.0522,
    imageUrls: [
      "https://www.theindiahotel.com/extra-images/banner-01.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgCXf3HATaGRx4_GtvzW8FVnYfXKRQMuRzOg&s",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/de/f7/c3/standard-room.jpg?w=1200&h=-1&s=1",
      "https://radissonhotels.iceportal.com/image/radisson-hotel-kathmandu/exterior/16256-114182-f75152296_3xl.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1P0AxSntzNAgs2_Qnl1IJCb2EebN82-KbPg&s",
    ],
    category: "Full Apartments",
    amenities: ["Wi-Fi Included", "Self-Catering Units", "Furnished Spaces", "Security"],
    distanceFromCampus: 0.8,
    bedAndBathroom: "3 beds . 2 bathrooms",
    university: "University of Zimbabwe",
    city: "Harare",
    agentId: "agent003",
    agentName: "Tendai Mutasa",
    agentProfilePic: "https://example.com/tendai_mutasa_profile.jpg",
    isVerified: true,
    isAvailable: true,
    description: "A spacious apartment suitable for a group of UZ students. Fully furnished with modern amenities.",
  ),
  Accommodation(
    title: "Luxury Student Living Complex near CUT",
    image:
        "https://lyon.intercontinental.com/wp-content/uploads/sites/6/2019/11/Superior-Room-cEric-Cuvillier-2.jpg",
    rating: 4.33,
    price: 250,
    address: "101 Campus Road, Chinhoyi",
    review: 236,
    latitude: -17.3667,
    longitude: 30.2000,
    imageUrls: [
      "https://lyon.intercontinental.com/wp-content/uploads/sites/6/2019/11/Superior-Room-cEric-Cuvillier-2.jpg",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/de/f7/c3/standard-room.jpg?w=1200&h=-1&s=1",
      "https://www.grandhotelnepal.com/images/slideshow/3arzB-grand4.jpg",
    ],
    category: "Luxury Student Living",
    amenities: ["Wi-Fi Included", "Furnished Spaces", "Close to Campus", "Gym", "Study Rooms"],
    distanceFromCampus: 0.3,
    bedAndBathroom: "1 bed . Private bathroom",
    university: "Chinhoyi University of Technology",
    city: "Chinhoyi",
    agentId: "agent004",
    agentName: "Chipo Mhaka",
    agentProfilePic: "https://example.com/chipo_mhaka_profile.jpg",
    isVerified: true,
    isAvailable: true,
    description: "Experience luxury student living near CUT. This complex offers premium amenities and comfort.",
  ),
  Accommodation(
    title: "Girls-Only Boarding House for CUT Students",
    image: "https://media.timeout.com/images/105162711/image.jpg",
    rating: 4.1,
    price: 120,
    review: 292,
    address: "202 University Hall, Chinhoyi",
    latitude: -17.3594,
    longitude: 30.1912,
    imageUrls: [
      "https://media.timeout.com/images/105162711/image.jpg",
      "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_Kz2H05mZVaPIZWVbXRADEASKvBCLJv4oeg&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRctRmBUpKa5HWwWKaL9TeVTZNHfabImL8cLQ&s",
    ],
    category: "Girls-Only Housing",
    amenities: ["Wi-Fi Included", "Close to Campus", "Verified Listings", "24/7 Security"],
    distanceFromCampus: 0.1,
    bedAndBathroom: "2 beds . Shared bathroom",
    university: "Chinhoyi University of Technology",
    city: "Chinhoyi",
    agentId: "agent005",
    agentName: "Grace Mugabe",
    agentProfilePic: "https://example.com/grace_mugabe_profile.jpg",
    isVerified: true,
    isAvailable: true,
    description: "A safe and comfortable girls-only boarding house very close to CUT campus. Ideal for female students.",
  ),
];

