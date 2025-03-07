// // ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:wasteapp/core/services/location/location_services.dart';
// import 'package:weather/weather.dart';
// import 'package:location/location.dart';

// class WeatherUpdateWidget extends StatefulWidget {
//   const WeatherUpdateWidget({super.key});

//   @override
//   State<WeatherUpdateWidget> createState() => _WeatherUpdateWidgetState();
// }

// enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

// class _WeatherUpdateWidgetState extends State<WeatherUpdateWidget> {
//   late LocationServices locationServices;
//   final String apiKey = 'dd323a6139067e1ad0eeb1e0f9f4db2c';
//   late WeatherFactory weatherService;
//   Location location = Location();
//   List<Weather> _weatherData = [];
//   AppState _state = AppState.NOT_DOWNLOADED;
//   double? latitude, longitude;

//   @override
//   void initState() {
//     super.initState();
//     locationServices = LocationServices();
//     weatherService = WeatherFactory(apiKey);
//     _setCurrentLocation();
//   }

//   Future<void> _setCurrentLocation() async {
//     // Get the current location
//     final LocationData? currentLocation =
//         await locationServices.getCurrentLocation();

//     if (currentLocation != null) {
//       latitude = currentLocation.latitude;
//       longitude = currentLocation.longitude;
//     } else {
//       latitude = 38.8951;
//       longitude = 77.0364;
//     }

//     fetchWeather();
//   }

//   Future<void> fetchWeather() async {
//     if (latitude == null || longitude == null) return;

//     setState(() {
//       _state = AppState.DOWNLOADING;
//     });

//     try {
//       Weather weather = await weatherService.currentWeatherByLocation(
//         latitude!,
//         longitude!,
//       );
//       setState(() {
//         _weatherData = [weather];
//         _state = AppState.FINISHED_DOWNLOADING;
//       });
//     } catch (error) {
//       setState(() {
//         _state = AppState.NOT_DOWNLOADED;
//       });
//     }
//   }

//   Widget weatherContent() {
//     if (_state == AppState.NOT_DOWNLOADED) {
//       return const Center(child: Text('Waiting for data...'));
//     } else if (_state == AppState.DOWNLOADING) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_state == AppState.FINISHED_DOWNLOADING &&
//         _weatherData.isNotEmpty) {
//       Weather weather = _weatherData.first;
//       int temp = weather.temperature?.celsius?.round() ?? 0;
//       String description = weather.weatherDescription ?? '';
//       String location = weather.areaName ?? '';

//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 location,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//               Text('$temp°C', style: const TextStyle(fontSize: 24.0)),
//               Text(description, style: const TextStyle(fontSize: 14.0)),
//             ],
//           ),
//           if (weather.weatherIcon != null)
//             Image.network(
//               'https://openweathermap.org/img/w/${weather.weatherIcon}.png',
//               width: 80.0,
//               height: 80.0,
//               fit: BoxFit.cover,
//             ),
//         ],
//       );
//     }
//     return const Text('Error fetching weather data.');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             offset: const Offset(0, 2),
//             blurRadius: 4.0,
//           ),
//         ],
//       ),
//       child: Column(children: [weatherContent()]),
//     );
//   }
// }
