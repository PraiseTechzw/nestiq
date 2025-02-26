import 'package:nestiq/Components/location_in_map.dart';
import 'package:nestiq/Components/my_icon_button.dart';
import 'package:nestiq/Components/star_rating.dart';
import 'package:nestiq/Provider/favorite_provider.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  int currentIndex = 0;
  final double _sectionSpacing = 28.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final provider = FavoriteProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.35,
            flexibleSpace: _buildImageCarousel(size, provider),
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              MyIconButton(icon: Icons.share_outlined),
              const SizedBox(width: 12),
              _buildFavoriteButton(provider),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(theme),
                  SizedBox(height: _sectionSpacing),
                  _buildPropertyHighlights(),
                  SizedBox(height: _sectionSpacing),
                  _buildAmenitiesSection(theme),
                  SizedBox(height: _sectionSpacing),
                  _buildHostSection(),
                  SizedBox(height: _sectionSpacing),
                  _buildDescriptionSection(theme),
                  SizedBox(height: _sectionSpacing),
                  _buildLocationSection(theme, size),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomReservationBar(size, theme),
    );
  }

  Widget _buildImageCarousel(Size size, FavoriteProvider provider) {
    return Stack(
      children: [
        AnotherCarousel(
          images: (widget.place['imageUrls'] as List<dynamic>)
              .map((url) => NetworkImage(url.toString()))
              .toList(),
          showIndicator: false,
          dotBgColor: Colors.transparent,
          onImageChange: (_, index) => setState(() => currentIndex = index),
          boxFit: BoxFit.cover,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "${currentIndex + 1}/${widget.place['imageUrls'].length}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.place['title'],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_pin, size: 18, color: theme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${widget.place['address']} • ${widget.place['distanceFromCampus']} km from campus",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            StarRating(rating: widget.place['rating']?.toDouble() ?? 0.0),
            const SizedBox(width: 8),
            Text(
              "${widget.place['rating']} (${widget.place['review']} reviews)",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            if (widget.place['isVerified'] == true)
              _buildFeatureChip("Verified", Icons.verified, Colors.blue),
            _buildFeatureChip(
              widget.place['category'],
              Icons.category,
              Colors.green,
            ),
            _buildFeatureChip(
              widget.place['bedAndBathroom'],
              Icons.bed,
              Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertyHighlights() {
    return Column(
      children: [
        _buildHighlightItem(
          icon: Icons.diamond,
          title: "Premium Listing",
          subtitle: "This property offers exceptional value",
        ),
        const Divider(),
        _buildHighlightItem(
          icon: Icons.security,
          title: "Safety Features",
          subtitle: "24/7 security • Fire safety equipment",
        ),
        const Divider(),
        _buildHighlightItem(
          icon: Icons.wifi,
          title: "Amenities Included",
          subtitle: "High-speed WiFi • Laundry facilities",
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amenities",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (widget.place['amenities'] as List<dynamic>)
              .map((amenity) => Chip(
                    label: Text(amenity.toString()),
                    backgroundColor: Colors.grey.shade100,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHostSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(widget.place['agentProfilePic']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hosted by ${widget.place['agentName']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this space",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.place['description'],
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(ThemeData theme, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.place['address'],
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomReservationBar(Size size, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$${widget.place['price']}",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                "per month",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            icon: const Icon(Icons.event_available, size: 20),
            label: const Text("Reserve Now"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(text),
      labelStyle: const TextStyle(color: Colors.white),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildFavoriteButton(FavoriteProvider provider) {
    return IconButton(
      icon: Icon(
        provider.isExist(widget.place) ? Icons.favorite : Icons.favorite_border,
        color: provider.isExist(widget.place) ? Colors.red : Colors.white,
        size: 28,
      ),
      onPressed: () => provider.toggleFavorite(widget.place),
    );
  }
}

