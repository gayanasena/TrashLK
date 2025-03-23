import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wasteapp/features/home/presentation/widgets/search_bar_without_filter.dart';

class NearByBins extends StatefulWidget {
  const NearByBins({super.key});

  @override
  _NearByBinsState createState() => _NearByBinsState();
}

class _NearByBinsState extends State<NearByBins> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get User's Current Location
  Future<void> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return _showError("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _showError("Location permission denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return _showError("Location permissions are permanently denied.");
    }

    // Get user's current position
    Position position = await Geolocator.getCurrentPosition();
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = userLocation;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: userLocation,
          infoWindow: const InfoWindow(title: "Your Location"),
        ),
      );
    });

    // Move camera to user's location
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(userLocation, 15));
  }

  // Search Location by Address
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newLocation = LatLng(location.latitude, location.longitude);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(query),
              position: newLocation,
              infoWindow: InfoWindow(title: query),
            ),
          );
        });

        // Move camera to user's location
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 15),
        );
      }
    } catch (e) {
      _showError("Location not found!");
    }
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Nearby Bins')),
      body: Stack(
        children: [
          // Google Map
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 32.0),
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(0, 0),
                zoom: 14.0,
              ),
              markers: _markers,
            ),
          ),

          // Search Bar
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5.0),
                ],
              ),
              child: SearchBarWithoutFilter(
                controller: _searchController,
                onPressed: () async => _searchLocation(_searchController.text),
                placeholderText: "Search location...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
