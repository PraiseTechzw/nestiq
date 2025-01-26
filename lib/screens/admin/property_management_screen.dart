import 'package:flutter/material.dart';
import 'package:nestiq/services/admin_service.dart';
import 'package:nestiq/widgets/property_card.dart';

class PropertyManagementScreen extends StatelessWidget {
  const PropertyManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Property Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Verified'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PropertyList(),
            _PropertyList(status: 'pending'),
            _PropertyList(status: 'verified'),
          ],
        ),
      ),
    );
  }
}

class _PropertyList extends StatelessWidget {
  final String? status;

  const _PropertyList({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AdminService().getProperties(status: status),
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
              isAdmin: true,
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
    );
  }
}

