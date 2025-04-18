class Booking {
  final int? id;
  final String hotelName;
  final String hotelImageUrl;
  final String userName;
  final String userEmail;
  final String checkInDate;
  final String checkOutDate;
  final int guests;
  final String specialRequests;
  final double totalPrice;

  Booking({
    this.id,
    required this.hotelName,
    required this.hotelImageUrl,
    required this.userName,
    required this.userEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.specialRequests,
    required this.totalPrice,
  });

  // Convert a Booking object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hotelName': hotelName,
      'hotelImageUrl': hotelImageUrl,
      'userName': userName,
      'userEmail': userEmail,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'guests': guests,
      'specialRequests': specialRequests,
      'totalPrice': totalPrice,
    };
  }

  // Convert a Map into a Booking object
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      hotelName: map['hotelName'],
      hotelImageUrl: map['hotelImageUrl'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      checkInDate: map['checkInDate'],
      checkOutDate: map['checkOutDate'],
      guests: map['guests'],
      specialRequests: map['specialRequests'],
      totalPrice: map['totalPrice'] is int
          ? (map['totalPrice'] as int).toDouble()
          : map['totalPrice'],
    );
  }
}
