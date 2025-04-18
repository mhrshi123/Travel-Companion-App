// Add to widgets folder: booking_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hotel_model.dart';
import '../models/booking_model.dart';

class BookingDialog extends StatefulWidget {
  final Hotel hotel;

  const BookingDialog({super.key, required this.hotel});

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _guestsController = TextEditingController(text: '1');
  final _requestsController = TextEditingController();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _guestsController.dispose();
    _requestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book Hotel'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Check-in'),
                        child: Text(
                          _checkInDate == null
                              ? 'Select date'
                              : DateFormat.yMMMd().format(_checkInDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _checkInDate == null
                          ? null
                          : _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Check-out'),
                        child: Text(
                          _checkOutDate == null
                              ? 'Select date'
                              : DateFormat.yMMMd().format(_checkOutDate!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(labelText: 'Number of Guests'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of guests';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requestsController,
                decoration: const InputDecoration(labelText: 'Special Requests'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Total Price: \$${(widget.hotel.price * (int.tryParse(_guestsController.text) ?? 1)).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _checkInDate != null &&
                _checkOutDate != null) {
              Navigator.pop(
                context,
                Booking(
                  hotelName: widget.hotel.name,
                  hotelImageUrl: widget.hotel.imageUrl,
                  userName: _nameController.text,
                  userEmail: _emailController.text,
                  checkInDate: DateFormat('yyyy-MM-dd').format(_checkInDate!),
                  checkOutDate: DateFormat('yyyy-MM-dd').format(_checkOutDate!),
                  guests: int.parse(_guestsController.text),
                  specialRequests: _requestsController.text,
                  totalPrice: widget.hotel.price * int.parse(_guestsController.text).toDouble(),
                ),
              );
            }
          },
          child: const Text('Confirm Booking'),
        ),
      ],
    );
  }
}