import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingCard extends StatelessWidget {
  final dynamic booking;
  final bool isAgent;
  final VoidCallback? onTap;

  const BookingCard({
    Key? key,
    required this.booking,
    this.isAgent = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewingTime = booking['viewingTime'].toDate();
    final status = booking['status'];

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['propertyTitle'],
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['propertyLocation'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${viewingTime.day}/${viewingTime.month}/${viewingTime.year}',
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${viewingTime.hour}:${viewingTime.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                  if (!isAgent)
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(booking['agentPhoto']),
                    )
                  else
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(booking['studentPhoto']),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

