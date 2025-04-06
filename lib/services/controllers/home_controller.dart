import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
class HomeController extends GetxController {
  var currentPosition = Rxn<Position>(); // nullable reactive position
  var isLoadingLocation = false.obs;
  var locationError = ''.obs;
  var latlong=''.obs;
  var streetName = ''.obs;
  var localityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    isLoadingLocation.value = true;
    locationError.value = '';
    streetName.value = '';
    localityName.value = '';

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'Location services are disabled.';
        isLoadingLocation.value = false;
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permission is denied';
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permission is permanently denied. Please enable it from app settings.';
        await AppSettings.openAppSettings();
        isLoadingLocation.value = false;
        return;
      }

      // Get current position
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      log('Current position: ${currentPosition.value?.latitude}');
      latlong.value='${currentPosition.value?.latitude},${currentPosition.value?.longitude}';
      // Reverse geocoding
    List<Placemark> placemarks = await placemarkFromCoordinates(
  currentPosition.value!.latitude,
  currentPosition.value!.longitude,
);

if (placemarks.isNotEmpty) {
  final place = placemarks.first;
  streetName.value = '${place.street},${place.locality},${place.administrativeArea}';
  // localityName.value = place.locality ?? '';
  // log('Street: ${streetName.value}, Locality: ${localityName.value}');
   log('Current position: ${streetName.value}');
  isLoadingLocation.value = false;
}
isLoadingLocation.value = false;

    } catch (e) {
      locationError.value = 'Failed to get location: $e';
      isLoadingLocation.value = false;
      // print('Location fetch error: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
