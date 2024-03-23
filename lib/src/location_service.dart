import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so you may want to prompt the user to turn them on.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, so you may want to prompt the user to open the app settings.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, so you may want to prompt the user to open the app settings.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<Position> getCurrentLocation() async {
    try {
      return await _determinePosition();
    } catch (e) {
      return Future.error('Error fetching current location');
    }
  }
}
