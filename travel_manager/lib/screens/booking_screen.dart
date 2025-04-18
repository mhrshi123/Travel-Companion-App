import 'package:flutter/material.dart';
import 'package:travel_manager/database/database_helper.dart';
import 'package:travel_manager/models/booking_model.dart';
import 'package:travel_manager/screens/login_page.dart'; // Ensure this is the correct path to LoginPage

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  Future<void> _deleteBooking(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {}); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Booking>>(
        future: DatabaseHelper.instance.getBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings yet'));
          }
          
          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Dismissible(
                key: Key(booking.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) => _deleteBooking(booking.id!),
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      booking.hotelImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(booking.hotelName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${booking.checkInDate} - ${booking.checkOutDate}'),
                        Text('Guests: ${booking.guests}'),
                        Text('Total: \$${booking.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteBooking(booking.id!),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}