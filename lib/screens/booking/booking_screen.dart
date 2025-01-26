import 'package:flutter/material.dart';
import 'package:nestiq/services/booking_service.dart';
import 'package:nestiq/widgets/booking_card.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Pending'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(status: 'upcoming'),
            _BookingList(status: 'pending'),
            _BookingList(status: 'past'),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final String status;

  const _BookingList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BookingService().getBookingsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No $status bookings'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final booking = snapshot.data!.docs[index];
            return BookingCard(
              booking: booking,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/booking-details',
                  arguments: booking.id,
                );
              },
            );
          },
        );
      },
    );
  }
}

