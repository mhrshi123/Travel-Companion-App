import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_manager/models/destination_model.dart';
import 'package:travel_manager/widgets/hotel_carousel.dart';
import 'package:travel_manager/widgets/hotel_search_delegate.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;

  const DestinationScreen({super.key, required this.destination});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  String _sortOption = 'price'; // Default sort option
  bool _sortAscending = true;

  void _handleSearchPressed(BuildContext context) {
    showSearch(
      context: context,
      delegate: HotelSearchDelegate(destinationCity: widget.destination.city),
    );
  }

  void _handleSortPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Sort Hotels By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            RadioListTile(
              title: const Text('Price (Low to High)'),
              value: 'price_asc',
              groupValue: '${_sortOption}_${_sortAscending ? 'asc' : 'desc'}',
              onChanged: (value) {
                setState(() {
                  _sortOption = 'price';
                  _sortAscending = true;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Price (High to Low)'),
              value: 'price_desc',
              groupValue: '${_sortOption}_${_sortAscending ? 'asc' : 'desc'}',
              onChanged: (value) {
                setState(() {
                  _sortOption = 'price';
                  _sortAscending = false;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Name (A-Z)'),
              value: 'name_asc',
              groupValue: '${_sortOption}_${_sortAscending ? 'asc' : 'desc'}',
              onChanged: (value) {
                setState(() {
                  _sortOption = 'name';
                  _sortAscending = true;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Name (Z-A)'),
              value: 'name_desc',
              groupValue: '${_sortOption}_${_sortAscending ? 'asc' : 'desc'}',
              onChanged: (value) {
                setState(() {
                  _sortOption = 'name';
                  _sortAscending = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Image with Info
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.destination.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      image: AssetImage(widget.destination.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // App Bar with Back Button and Actions
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          iconSize: 30.0,
                          color: Colors.black,
                          onPressed: () => _handleSearchPressed(context),
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.sortAmountDown),
                          iconSize: 25.0,
                          color: Colors.black,
                          onPressed: _handleSortPressed,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Destination Info Overlay
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationArrow,
                          size: 15.0,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          widget.destination.country,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Location Pin Icon
              Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Icon(
                  Icons.location_on,
                  color: Colors.white.withOpacity(0.9),
                  size: 30.0,
                ),
              ),
            ],
          ),
          
          // Hotels List
          Expanded(
            child: HotelCarousel(
              destinationCity: widget.destination.city,
              sortOption: _sortOption,
              sortAscending: _sortAscending,
            ),
          ),
        ],
      ),
    );
  }
}