import 'package:flutter/material.dart';
import 'package:nestiq/models/property.dart';
import 'package:nestiq/services/property_service.dart';
import 'package:nestiq/widgets/filter_sheet.dart';
import 'package:nestiq/widgets/property_card.dart';

class PropertyListingsScreen extends StatefulWidget {
  const PropertyListingsScreen({Key? key}) : super(key: key);

  @override
  _PropertyListingsScreenState createState() => _PropertyListingsScreenState();
}

class _PropertyListingsScreenState extends State<PropertyListingsScreen> {
  final _searchController = TextEditingController();
  PropertyType? _selectedType;
  double _minPrice = 0;
  double _maxPrice = 5000;
  String? _selectedLocation;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterSheet(
        selectedType: _selectedType,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        selectedLocation: _selectedLocation,
        onApply: (type, min, max, location) {
          setState(() {
            _selectedType = type;
            _minPrice = min;
            _maxPrice = max;
            _selectedLocation = location;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: PropertyService().getProperties(
                type: _selectedType,
                minPrice: _minPrice,
                maxPrice: _maxPrice,
                location: _selectedLocation,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No properties found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final property = snapshot.data!.docs[index];
                    return PropertyCard(
                      property: property,
                      isHorizontal: true,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/property-details',
                          arguments: property.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

