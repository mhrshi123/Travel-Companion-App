import 'package:flutter/material.dart';
import 'package:travel_manager/database/database_helper.dart';
import 'package:travel_manager/models/hotel_model.dart';
import 'package:travel_manager/screens/hotel_detail_screen.dart';

class HotelCarousel extends StatefulWidget {
  final String destinationCity;
  final String sortOption;
  final bool sortAscending;

  const HotelCarousel({
    super.key,
    required this.destinationCity,
    this.sortOption = 'price',
    this.sortAscending = true,
  });

  @override
  State<HotelCarousel> createState() => _HotelCarouselState();
}

class _HotelCarouselState extends State<HotelCarousel> {
  List<Hotel> hotels = [];

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  @override
  void didUpdateWidget(covariant HotelCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinationCity != widget.destinationCity ||
        oldWidget.sortOption != widget.sortOption ||
        oldWidget.sortAscending != widget.sortAscending) {
      _loadHotels();
    }
  }

  Future<void> _loadHotels() async {
    final results = await DatabaseHelper.instance.getHotelsByDestination(widget.destinationCity);
    List<Hotel> sorted = List.from(results);

    if (widget.sortOption == 'price') {
      sorted.sort((a, b) =>
          widget.sortAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    } else if (widget.sortOption == 'name') {
      sorted.sort((a, b) =>
          widget.sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    }

    setState(() {
      hotels = sorted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exclusive Hotels',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // Optional: Navigate to full list of hotels
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: hotels.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 240,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              bottom: 15,
                              child: Container(
                                height: 120,
                                width: 240,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      hotel.name,
                                      style: const TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      hotel.address,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '\$${hotel.price} / night',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  hotel.imageUrl,
                                  height: 180,
                                  width: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
