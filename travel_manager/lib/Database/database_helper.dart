import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hotel_model.dart';
import '../models/booking_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('travel_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path); // optional for debugging

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hotels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        price INTEGER NOT NULL,
        imageUrl TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        destinationCity TEXT NOT NULL
      )
    ''');

    // In database_helper.dart, add to _createDB method:
    await db.execute('''
    CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT
  )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hotel_id INTEGER NOT NULL,
        FOREIGN KEY (hotel_id) REFERENCES hotels (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_favorites_hotel_id ON favorites(hotel_id)',
    );
    await db.execute('CREATE INDEX idx_hotels_city ON hotels(destinationCity)');

    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hotelName TEXT NOT NULL,
        hotelImageUrl TEXT NOT NULL,
        userName TEXT NOT NULL,
        userEmail TEXT NOT NULL,
        checkInDate TEXT NOT NULL,
        checkOutDate TEXT NOT NULL,
        guests INTEGER NOT NULL,
        specialRequests TEXT NOT NULL,
        totalPrice REAL NOT NULL
      )
    ''');

    // Sample data
    await db.insert('hotels', {
      'name': 'Hotel Danieli',
      'address': 'Riva degli Schiavoni, Venice',
      'price': 350,
      'imageUrl': 'assets/images/hotel0.jpg',
      'latitude': 45.4343,
      'longitude': 12.3398,
      'destinationCity': 'Venice',
    });
    await db.insert('hotels', {
      'name': 'Hotel Gritti Palace',
      'address': 'Campo Santa Maria, Venice',
      'price': 450,
      'imageUrl': 'assets/images/hotel1.jpg',
      'latitude': 45.4319,
      'longitude': 12.3333,
      'destinationCity': 'Venice',
    });
    await db.insert('hotels', {
      'name': 'Hotel Lutetia',
      'address': '45 Boulevard Raspail, Paris',
      'price': 400,
      'imageUrl': 'assets/images/hotel2.jpg',
      'latitude': 48.8468,
      'longitude': 2.3276,
      'destinationCity': 'Paris',
    });
    await db.insert('hotels', {
      'name': 'Shangri-La Paris',
      'address': '10 Avenue d’Iéna, Paris',
      'price': 500,
      'imageUrl': 'assets/images/hotel0.jpg',
      'latitude': 48.8637,
      'longitude': 2.2936,
      'destinationCity': 'Paris',
    });
    await db.insert('hotels', {
      'name': 'The Oberoi',
      'address': 'Dr Zakir Hussain Marg, New Delhi',
      'price': 250,
      'imageUrl': 'assets/images/hotel1.jpg',
      'latitude': 28.5961,
      'longitude': 77.2416,
      'destinationCity': 'New Delhi',
    });
    await db.insert('hotels', {
      'name': 'Taj Palace',
      'address': 'Sardar Patel Marg, New Delhi',
      'price': 200,
      'imageUrl': 'assets/images/hotel2.jpg',
      'latitude': 28.5951,
      'longitude': 77.1713,
      'destinationCity': 'New Delhi',
    });
  }

  // In database_helper.dart
  Future<int?> createUser(String email, String password, {String? name}) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'email': email,
        'password': password, // Note: In production, hash passwords!
        'name': name,
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return null; // Email already exists
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> validateUser(String email, String password) async {
    final user = await getUser(email);
    if (user == null) return false;
    return user['password'] == password; // In production, use password hashing!
  }

  Future<void> addFavorite(int hotelId) async {
    final db = await database;
    await db.insert('favorites', {'hotel_id': hotelId});
  }

  Future<void> removeFavorite(int hotelId) async {
    final db = await database;
    await db.delete('favorites', where: 'hotel_id = ?', whereArgs: [hotelId]);
  }

  Future<List<Hotel>> getFavorites() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT hotels.* FROM hotels
      JOIN favorites ON hotels.id = favorites.hotel_id
    ''');
    return maps.map((map) => Hotel.fromMap(map)).toList();
  }

  Future<bool> isFavorite(int hotelId) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'hotel_id = ?',
      whereArgs: [hotelId],
    );
    return maps.isNotEmpty;
  }

  Future<List<Hotel>> getHotelsByDestination(String city) async {
    final db = await database;
    final maps = await db.query(
      'hotels',
      where: 'destinationCity = ?',
      whereArgs: [city],
    );

    return maps.map((map) => Hotel.fromMap(map)).toList();
  }

  Future<void> insertHotel(Hotel hotel) async {
    final db = await database;
    await db.insert('hotels', hotel.toMap());
  }

  Future<void> insertBooking(Booking booking) async {
    final db = await database;
    await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookings() async {
    final db = await database;
    final maps = await db.query('bookings');
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
