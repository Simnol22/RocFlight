import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roc_flight/src/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roc_flight/src/model/rocket.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _currentPosition;
  LatLng? _rocketLocation;

  Position? get currentPosition => _currentPosition;
  LatLng? get rocketLocation => _rocketLocation;

  // Create a placeholder Rocket instance
  Rocket placeholderRocket = Rocket(
    rocketId: 'placeholder_rocket_id', // Placeholder ID
    latitude: 45.5017, // Placeholder latitude (e.g., Montreal)
    longitude: -73.5673, // Placeholder longitude (e.g., Montreal)
  );

  Future<void> fetchUserLocation() async {
    bool hasPermission =
        await _locationService.checkAndRequestLocationPermissions();
    if (hasPermission) {
      try {
        Position position = await _locationService.getCurrentLocation();
        _currentPosition = position;
      } catch (e) {
        print('Error fetching current location: $e');
        // Don't update _currentPosition in case of an error
      }
    } else {
      print('Location permissions not granted or location services disabled.');
    }

    notifyListeners(); // Notify the UI regardless to update based on available data
  }

  Future<void> fetchRocketLocation(String rocketId) async {
    // Check if the rocketId is the placeholder ID
    if (rocketId == 'placeholder_rocket_id') {
      // Directly set the placeholder data without fetching from Firestore
      _rocketLocation = const LatLng(
          45.5017, -73.5673); // Using Montreal as the placeholder location
      notifyListeners();
    } else {
      // Proceed with the actual Firestore fetching logic
      try {
        var docSnapshot =
            await _firestore.collection('rockets').doc(rocketId).get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data = docSnapshot.data()!;
          double latitude = data['latitude'];
          double longitude = data['longitude'];
          _rocketLocation = LatLng(latitude, longitude);
          notifyListeners();
        }
      } catch (e) {
        print("Error fetching rocket location: $e");
      }
    }
  }

  // Calculate the distance to the rocket location
  double calculateDistanceToRocket() {
    if (_currentPosition == null || _rocketLocation == null) {
      return 0.0;
    }
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      _rocketLocation!.latitude,
      _rocketLocation!.longitude,
    );
  }
}
