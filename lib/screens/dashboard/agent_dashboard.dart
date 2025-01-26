import 'package:flutter/material.dart';
import 'package:nestiq/services/property_service.dart';
import 'package:nestiq/services/booking_service.dart';

import 'package:nestiq/widgets/stats_card.dart';

class AgentDashboard extends StatelessWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh dashboard data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Overview
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Active Listings',
                        value: '12',
                        icon: Icons.home_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Pending Viewings',
                        value: '5',
                        icon: Icons.calendar_today_outlined,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total Revenue',
                        value: '\$15,200',
                        icon: Icons.attach_money_outlined,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Avg Rating',
                        value: '4.8',
                        icon: Icons.star_outline,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Bookings Section
                _SectionTitle(
                  title: 'Recent Bookings',
                  onSeeAll: () => Navigator.pushNamed(context, '/bookings'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: StreamBuilder(
                    stream: BookingService().getAgentBookings(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No recent bookings'),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final booking = snapshot.data!.docs[index];
                          return BookingCard(
                            booking: booking,
                            isAgent: true,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Your Properties Section
                _SectionTitle(
                  title: 'Your Properties',
                  onSeeAll: () => Navigator.pushNamed(context, '/my-properties'),
                ),
                const SizedBox(height: 8),
                StreamBuilder(
                  stream: PropertyService().getAgentProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No properties listed'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final property = snapshot.data!.docs[index];
                        return PropertyCard(
                          property: property,
                          isHorizontal: true,
                          isAgent: true,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_home_outlined),
            label: 'Add Property',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Bookings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/add-property');
              break;
            case 2:
              Navigator.pushNamed(context, '/messages');
              break;
            case 3:
              Navigator.pushNamed(context, '/bookings');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-property');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

