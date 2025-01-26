import 'package:flutter/material.dart';
import 'package:nestiq/services/admin_service.dart';
import 'package:nestiq/widgets/review_card.dart';

class ReviewManagementScreen extends StatelessWidget {
  const ReviewManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Management'),
      ),
      body: StreamBuilder(
        stream: AdminService().getReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No reviews found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final review = snapshot.data!.docs[index];
              return ReviewCard(
                review: review,
                isAdmin: true,
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Review'),
                      content: const Text(
                        'Are you sure you want to delete this review?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await AdminService().deleteReview(review.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

