import 'package:flutter/material.dart';
import 'package:nestiq/services/admin_service.dart';
import 'package:nestiq/widgets/stats_card.dart';
import 'package:nestiq/widgets/verification_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/admin-settings');
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
                // Platform Stats
                Text(
                  'Platform Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total Users',
                        value: '1,234',
                        icon: Icons.people_outline,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Properties',
                        value: '567',
                        icon: Icons.home_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Active Bookings',
                        value: '89',
                        icon: Icons.calendar_today_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Revenue',
                        value: '\$12,345',
                        icon: Icons.attach_money_outlined,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pending Verifications
                _SectionTitle(
                  title: 'Pending Verifications',
                  onSeeAll: () => Navigator.pushNamed(context, '/verifications'),
                ),
                const SizedBox(height: 16),
                StreamBuilder(
                  stream: AdminService().getUnverifiedProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No pending property verifications'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final property = snapshot.data!.docs[index];
                        return VerificationCard(
                          title: property['title'],
                          subtitle: 'Property Verification',
                          type: VerificationType.property,
                          onApprove: () => AdminService().verifyProperty(
                            property.id,
                            true,
                          ),
                          onReject: () => AdminService().verifyProperty(
                            property.id,
                            false,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Agent Verifications
                StreamBuilder(
                  stream: AdminService().getUnverifiedUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No pending agent verifications'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data!.docs[index];
                        return VerificationCard(
                          title: user['fullName'],
                          subtitle: 'Agent Verification',
                          type: VerificationType.agent,
                          onApprove: () => AdminService().verifyUser(
                            user.id,
                            true,
                          ),
                          onReject: () => AdminService().verifyUser(
                            user.id,
                            false,
                          ),
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Property Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-properties');
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_outlined),
              title: const Text('Verifications'),
              onTap: () {
                Navigator.pushNamed(context, '/verifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-analytics');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionTitle({
    Key? key,
    required this.title,
    required this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }
}

