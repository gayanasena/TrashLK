// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/taxi_booking_model.dart';
import 'package:wasteapp/routes/routes_extension.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();
  late FlutterSecureStorage secureStorage;
  bool isGuestMode = false;

  late FirebaseServices firebaseServices;

  String? _selectedRideType;

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    secureStorage = const FlutterSecureStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Book a taxi", style: TextStyles(context).appBarText),
        elevation: 0,
      ),
      backgroundColor: ApplicationColors(context).appWhiteBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Pick-up Location Input
              const Text(
                "Pick-up Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _pickupController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: primaryColor,
                  ),
                  hintText: "Enter pick-up location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Drop-off Location Input
              const Text(
                "Drop-off Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dropOffController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: primaryColor,
                  ),
                  hintText: "Enter drop-off location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ride Options Section
              const Text(
                "Choose Your Ride",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _rideOption("Tuk", "2 seats", "assets/images/tuk.png"),
                    _rideOption("Flex", "3 seats", "assets/images/flex2.png"),
                    _rideOption("Car", "3 seats", "assets/images/flex.png"),
                    _rideOption("SUV", "5 seats", "assets/images/suv.png"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Booking Button
              Center(
                child:
                    isGuestMode
                        ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            _confirmBooking();
                          },
                          child: const Text(
                            "Confirm Booking",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                        : const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please login to make a booking',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ride Option Widget
  Widget _rideOption(String type, String seats, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRideType = type;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color:
                _selectedRideType == type
                    ? Colors.blue.shade100
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetPath, height: 60), // Replace with actual asset
              const SizedBox(height: 10),
              Text(
                type,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(seats, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Confirm Booking and send data to Firebase
  void _confirmBooking() {
    String pickupLocation = _pickupController.text;
    String dropOffLocation = _dropOffController.text;

    if (pickupLocation.isEmpty ||
        dropOffLocation.isEmpty ||
        _selectedRideType == null) {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select a ride type"),
        ),
      );
      return;
    }

    // Prepare data to be sent to Firebase
    TaxiBookingModel bookingData = TaxiBookingModel(
      userId: '',
      pickupLocation: pickupLocation,
      dropLocation: dropOffLocation,
      rideType: _selectedRideType ?? 'Standard',
      dateTime: DateTime.now().toString(),
    );

    // Send data to Firebase
    firebaseServices.saveBookingData(bookingModel: bookingData);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking Confirmed!"),
        backgroundColor: Colors.green,
      ),
    );

    context.popScreen();
  }
}
