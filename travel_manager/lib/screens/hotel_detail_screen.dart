import 'package:flutter/material.dart';
import 'package:travel_manager/models/hotel_model.dart';
import 'package:travel_manager/models/booking_model.dart';
import 'package:travel_manager/database/database_helper.dart';
import 'package:travel_manager/views/map_page.dart';
import 'package:travel_manager/widgets/booking_dialog.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  late Future<bool> _isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() {
    if (widget.hotel.id != null) {
      _isFavoriteFuture = DatabaseHelper.instance.isFavorite(widget.hotel.id!);
    } else {
      _isFavoriteFuture = Future.value(false);
    }
  }

  void _toggleFavorite() async {
    if (widget.hotel.id == null) return;

    final isFavorite = await DatabaseHelper.instance.isFavorite(widget.hotel.id!);

    if (isFavorite) {
      await DatabaseHelper.instance.removeFavorite(widget.hotel.id!);
    } else {
      await DatabaseHelper.instance.addFavorite(widget.hotel.id!);
    }

    if (mounted) {
      setState(() {
        _loadFavoriteStatus(); // refresh favorite icon
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
        actions: [
          if (hotel.id != null)
            FutureBuilder<bool>(
              future: _isFavoriteFuture,
              builder: (context, snapshot) {
                final isFavorite = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image(
                  image: AssetImage(hotel.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 20.0),
                      const SizedBox(width: 5.0),
                      Text(
                        hotel.address,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '\$${hotel.price} / night',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'About this hotel',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'A luxurious hotel located in the heart of ${hotel.destinationCity}. Enjoy world-class amenities and stunning views.',
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPage(
                              latitude: hotel.latitude,
                              longitude: hotel.longitude,
                              locationName: hotel.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('View on Map'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final booking = await showDialog<Booking>(
                          context: context,
                          builder: (context) => BookingDialog(hotel: hotel),
                        );

                        if (booking != null) {
                          await DatabaseHelper.instance.insertBooking(booking);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booking successful!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                      child: const Text('Add Booking'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
