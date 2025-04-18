import 'package:flutter/material.dart';
import 'package:travel_manager/models/hotel_model.dart';
import 'package:travel_manager/database/database_helper.dart';
import 'package:travel_manager/screens/hotel_detail_screen.dart'; // Adjust the path as necessary

class HotelSearchDelegate extends SearchDelegate {
  final String destinationCity;

  HotelSearchDelegate({required this.destinationCity});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<Hotel>>(
      future: DatabaseHelper.instance.getHotelsByDestination(destinationCity),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final results = snapshot.data!.where((hotel) =>
          hotel.name.toLowerCase().contains(query.toLowerCase()) ||
          hotel.address.toLowerCase().contains(query.toLowerCase()));
          
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final hotel = results.elementAt(index);
            return ListTile(
              title: Text(hotel.name),
              subtitle: Text(hotel.address),
              onTap: () {
                close(context, hotel);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelDetailScreen(hotel: hotel),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}