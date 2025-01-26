import 'package:flutter/material.dart';

enum VerificationType { property, agent }

class VerificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VerificationType type;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const VerificationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          type == VerificationType.property
              ? Icons.home_outlined
              : Icons.person_outline,
          color: Colors.blue,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: Colors.green,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Approval'),
                    content: Text('Are you sure you want to approve $title?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onApprove();
                          Navigator.pop(context);
                        },
                        child: const Text('Approve'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Rejection'),
                    content: Text('Are you sure you want to reject $title?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onReject();
                          Navigator.pop(context);
                        },
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

