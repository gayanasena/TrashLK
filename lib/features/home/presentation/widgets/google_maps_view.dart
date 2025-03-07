// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double longitude;
  final double latitude;
  final String title;
  final String description;

  const MapScreen({
    super.key,
    required this.longitude,
    required this.latitude,
    required this.title,
    required this.description,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng _center;
  @override
  void initState() {
    _center = LatLng(widget.latitude, widget.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('marker_1'),
            position: _center,
            infoWindow: InfoWindow(
              title: widget.title,
              snippet: widget.description,
            ),
          ),
        },
      ),
    );
  }
}
