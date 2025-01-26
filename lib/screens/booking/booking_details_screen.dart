import 'package:flutter/material.dart';
import 'package:nestiq/services/booking_service.dart';
import 'package:nestiq/widgets/custom_button.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: StreamBuilder(
        stream: BookingService().getBookingById(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Booking not found'));
          }

          final booking = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Viewing Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: booking['viewingTime'].toDate().toString(),
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          icon: Icons.access_time,
                          label: 'Status',
                          value: booking['status'],
                        ),
                        if (booking['notes'] != null) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            icon: Icons.note,
                            label: 'Notes',
                            value: booking['notes'],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Property Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.home,
                          label: 'Property',
                          value: booking['propertyTitle'],
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: booking['propertyLocation'],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.person,
                          label: 'Agent',
                          value: booking['agentName'],
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: booking['agentEmail'],
                        ),
                        const SizedBox(height: 8),
                        _DetailRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: booking['agentPhone'],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: bookingId,
                  );
                },
                child: const Text('Message Agent'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                isOutlined: true,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cancel Booking'),
                      content: const Text(
                        'Are you sure you want to cancel this booking?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await BookingService().cancelBooking(bookingId);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Cancel Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}

