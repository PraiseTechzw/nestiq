import 'package:flutter/material.dart';
import 'package:nestiq/Components/display_place.dart';
import 'package:nestiq/Components/display_total_price.dart';
import 'package:nestiq/Components/map_with_custom_info_windows.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CollectionReference categoryCollection = 
      FirebaseFirestore.instance.collection("StudentAccommodationCategories");
  int selectedIndex = 0;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SearchBarAndFilter(),
            _buildCategoryList(size),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DisplayTotalPrice(),
                    const SizedBox(height: 15),
                    DisplayPlace(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const MapWithCustomInfoWindows(),
    );
  }

  Widget _buildCategoryList(Size size) {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var category = snapshot.data!.docs[index];
                IconData icon = IconData(
                  category['icon'], 
                  fontFamily: 'MaterialIcons'
                );

                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedIndex == index 
                          ? const Color(0xFF006699) // Zim blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, 
                            color: selectedIndex == index 
                                ? Colors.white 
                                : Colors.black54),
                        const SizedBox(height: 8),
                        Text(
                          category['title'],
                          style: TextStyle(
                            color: selectedIndex == index 
                                ? Colors.white 
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class SearchBarAndFilter extends StatelessWidget {
  const SearchBarAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search hostels, universities or areas...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF006699)),
                    onPressed: () => _showFilterBottomSheet(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Filter Options",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              _buildFilterOption("Price Range", Icons.attach_money),
              _buildFilterOption("Amenities", Icons.wifi),
              _buildFilterOption("Distance from Campus", Icons.location_on),
              _buildFilterOption("Room Type", Icons.room_preferences),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006699),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Apply Filters",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF006699)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}