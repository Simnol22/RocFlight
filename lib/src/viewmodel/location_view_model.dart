import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roc_flight/src/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _currentPosition;
  LatLng? _rocketLocation;

  Position? get currentPosition => _currentPosition;
  LatLng? get rocketLocation => _rocketLocation;

  Future<void> fetchUserLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      _currentPosition = position;
    } catch (e) {
      print('Error fetching current location: $e');
      // Don't update _currentPosition in case of an error
    }
    notifyListeners(); // Notify the UI regardless to update based on available data
  }

  // Fetch the rocket's location from Firebase
  Future<void> fetchRocketLocation() async {
    try {
      var docSnapshot = await _firestore
          .collection('rockets')
          .doc('your_rocket_id') // TODO: Replace with rocket or flight ID
          .get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        _rocketLocation = LatLng(latitude, longitude);
        notifyListeners(); // Notify the UI that the rocket location has been updated
      }
    } catch (e) {
      print("Error fetching rocket location: $e");
      // Handle errors or set a default location as necessary
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
