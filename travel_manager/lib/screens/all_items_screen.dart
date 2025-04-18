import 'package:flutter/material.dart';
import 'package:travel_manager/models/hotel_model.dart';
import 'package:travel_manager/screens/hotel_detail_screen.dart'; // Import the HotelDetailScreen class

class AllItemsScreen extends StatelessWidget {
  final List<Hotel> items;
  final String title;

  const AllItemsScreen({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Image.asset(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.name),
            subtitle: Text('\$${item.price} / night'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetailScreen(hotel: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}