import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Checks and requests location permissions.
  /// Returns true if permissions are granted, otherwise false.
  Future<bool> checkAndRequestLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled. Prompt the user to turn them on.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied. Prompt the user to open app settings.
        return false; // Or consider returning Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever. Prompt the user to open app settings.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Permissions are granted.
    return true;
  }

  /// Gets the current location. Assumes location permissions have been granted.
  Future<Position> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      // Handle any errors that occur during location fetching.
      return Future.error('Error fetching current location');
    }
  }
}
