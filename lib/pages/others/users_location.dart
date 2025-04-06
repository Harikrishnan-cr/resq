// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _pickedLocation;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _setCurrentLocation();
//   }

//   Future<void> _setCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           throw Exception('Location permission denied');
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _pickedLocation = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//       setState(() {
//         _pickedLocation = LatLng(10.8505, 76.2711); // fallback to Kerala
//         _isLoading = false;
//       });
//     }
//   }

//   void _onMapTapped(LatLng position) {
//     setState(() {
//       _pickedLocation = position;
//     });
//   }

//   Future<void> _confirmLocation() async {
//     if (_pickedLocation == null) return;
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _pickedLocation!.latitude,
//         _pickedLocation!.longitude,
//       );

//       String address =
//           '${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
//       Navigator.pop(context, address);
//     } catch (e) {
//       Navigator.pop(context,
//           '${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading || _pickedLocation == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Select Location')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('Select Location')),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (controller) => _mapController = controller,
//             onTap: _onMapTapped,
//             initialCameraPosition: CameraPosition(
//               target: _pickedLocation!,
//               zoom: 14.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('pickedLocation'),
//                 position: _pickedLocation!,
//               )
//             },
//           ),
//           Positioned(
//             bottom: 16,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: _confirmLocation,
//               child: Text('Confirm Location'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
