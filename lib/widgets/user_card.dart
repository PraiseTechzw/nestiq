import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback? onTap;

  const UserCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
        ),
        title: Text(user['fullName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']),
            Text(
              'Joined ${timeago.format(user['createdAt'].toDate())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: user['isVerified']
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            user['isVerified'] ? 'Verified' : 'Pending',
            style: TextStyle(
              color: user['isVerified'] ? Colors.green : Colors.orange,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

