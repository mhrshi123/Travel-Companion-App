class Hotel {
  int id;  
  String name;
  String address;
  double price;  
  String imageUrl;
  double latitude;
  double longitude;
  String destinationCity;

  Hotel({
    required this.id,  
    required this.name,
    required this.address,
    required this.price,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.destinationCity,
  });

  factory Hotel.fromMap(Map<String, dynamic> map) => Hotel(
        id: map['id'],  
        name: map['name'],
        address: map['address'],
        price: map['price']?.toDouble() ?? 0.0,  
        imageUrl: map['imageUrl'],
        latitude: map['latitude']?.toDouble() ?? 0.0,  
        longitude: map['longitude']?.toDouble() ?? 0.0,  
        destinationCity: map['destinationCity'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,  // Add 'id' to the map
        'name': name,
        'address': address,
        'price': price,  
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'destinationCity': destinationCity,
      };
}
