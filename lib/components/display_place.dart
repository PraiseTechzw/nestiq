import 'package:nestiq/Provider/favorite_provider.dart';
import 'package:nestiq/view/place_detail_screen.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayPlace extends StatefulWidget {
  final String searchQuery;

  const DisplayPlace({super.key, required this.searchQuery});

  @override
  State<DisplayPlace> createState() => _DisplayPlaceState();
}

class _DisplayPlaceState extends State<DisplayPlace> {
  final CollectionReference accommodationCollection =
      FirebaseFirestore.instance.collection("studentAccommodationsListings");

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return StreamBuilder(
      stream: accommodationCollection.snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.hasData) {
          final filteredDocs = streamSnapshot.data!.docs.where((doc) {
            final title = doc['category'].toString().toLowerCase();
            return title.contains(widget.searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredDocs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final accommodation = filteredDocs[index];
              return _buildAccommodationCard(accommodation, provider, context);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAccommodationCard(
      QueryDocumentSnapshot accommodation, FavoriteProvider provider, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: accommodation)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageStack(accommodation, provider),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow(accommodation),
                    const SizedBox(height: 8),
                    _buildAddressRow(accommodation),
                    const SizedBox(height: 12),
                    _buildPriceRow(accommodation),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageStack(QueryDocumentSnapshot accommodation, FavoriteProvider provider) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: AnotherCarousel(
              images: accommodation['imageUrls']
                  .map<ImageProvider>((url) => NetworkImage(url))
                  .toList(),
              dotSize: 6,
              indicatorBgPadding: 5,
              dotBgColor: Colors.transparent,
              dotIncreasedColor: Colors.blueAccent,
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ],
            ),
            child: IconButton(
              icon: Icon(
                provider.isExist(accommodation) ? Icons.favorite : Icons.favorite_border,
                color: provider.isExist(accommodation) ? Colors.red : Colors.grey[700],
                size: 28,
              ),
              onPressed: () => provider.toggleFavorite(accommodation),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: _buildVerifiedBadge(accommodation),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildAgentProfile(accommodation),
        ),
      ],
    );
  }

  Widget _buildVerifiedBadge(QueryDocumentSnapshot accommodation) {
    if (accommodation['isVerified'] != true) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            "Verified",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentProfile(QueryDocumentSnapshot accommodation) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(accommodation['agentProfilePic']),
      ),
    );
  }

  Widget _buildTitleRow(QueryDocumentSnapshot accommodation) {
    return Row(
      children: [
        Expanded(
          child: Text(
            accommodation['category'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                accommodation['rating'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressRow(QueryDocumentSnapshot accommodation) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            accommodation['address'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(QueryDocumentSnapshot accommodation) {
    return RichText(
      text: TextSpan(
        text: '\$${accommodation['price']}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.blueAccent,
        ),
        children: const [
          TextSpan(
            text: ' /month',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}