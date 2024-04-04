import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roc_flight/src/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/model/flight.dart';

class LocationViewModel extends ChangeNotifier {
  final FlightViewModel _flightViewModel;
  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LocationViewModel(this._flightViewModel);

  Position? _currentPosition;
  LatLng? _rocketLocation;

  Position? get currentPosition => _currentPosition;
  LatLng? get rocketLocation => _rocketLocation;

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

  Future<void> fetchLatestRocketLocation() async {
    // Access the current active flight
    Flight? currentFlight = _flightViewModel.currentFlight;
    if (currentFlight == null) {
      print("No current flight selected.");
      return;
    }

    try {
      // Query the 'rockets' subcollection of the current flight, ordered by timestamp (newest first)
      var querySnapshot = await _firestore
          .collection('flights')
          .doc(currentFlight
              .uniqueId) // Assuming Flight model has an `id` property
          .collection('rockets')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data();
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        _rocketLocation = LatLng(latitude, longitude);
        notifyListeners(); // Notify listeners for UI update
      } else {
        print("No rockets found for the current flight.");
      }
    } catch (e) {
      print("Error fetching latest rocket location: $e");
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
