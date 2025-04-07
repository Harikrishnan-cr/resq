



import 'package:geolocator/geolocator.dart';

Future<String> getCurrentLatLong() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return '';

    // Check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return '';
    }

    if (permission == LocationPermission.deniedForever) {
      // Do not prompt again
      return '';
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return '${position.latitude},${position.longitude}';
  } catch (e) {
    // Optional: Log the error or handle silently
    return '';
  }
}
