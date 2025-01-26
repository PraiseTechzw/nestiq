import 'package:flutter/material.dart';
import 'package:nestiq/services/admin_service.dart';
import 'package:nestiq/widgets/user_card.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Users'),
              Tab(text: 'Students'),
              Tab(text: 'Agents'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _UserList(),
            _UserList(role: 'student'),
            _UserList(role: 'agent'),
          ],
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final String? role;

  const _UserList({Key? key, this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AdminService().getUsers(role: role),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final user = snapshot.data!.docs[index];
            return UserCard(
              user: user,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/user-details',
                  arguments: user.id,
                );
              },
            );
          },
        );
      },
    );
  }
}

