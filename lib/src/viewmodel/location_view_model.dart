import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:roc_flight/src/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/model/flight.dart';

class LocationViewModel extends ChangeNotifier {
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  final FlightViewModel _flightViewModel;
  final LocationService _locationService = LocationService();

  LocationViewModel(this._flightViewModel);

  LatLng? _rocketLocation;
  LatLng? get rocketLocation => _rocketLocation;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  LatLng? get currentLocation => currentPosition != null ? LatLng(currentPosition!.latitude, currentPosition!.longitude): null;

  double? get distanceToRocket => (currentLocation != null && rocketLocation != null) ? calculateDistanceToRocket() : null;

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

  void fetchLatestRocketLocation() {
    // Access the current active flight
    Flight? currentFlight = _flightViewModel.currentFlight;
    if (currentFlight == null) {
      print("No current flight selected.");
      return;
    }

    try {
      // Query the 'rockets' subcollection of the current flight, ordered by timestamp (newest first)
      collection
        .doc(_flightViewModel.currentFlight!.uniqueId)
        .collection("rocket")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get()
        .then(
          (snapshot) {
            final rocket = (snapshot.size > 0) 
              ? Rocket.fromFirestore(snapshot.docs[0].id, snapshot.docs[0].data())
              : null;

            if (rocket != null && rocket.coordinates != null) {
              var lat = rocket.coordinates!.latitude??0.0;
              var lon = rocket.coordinates!.longitude??0.0;
              _rocketLocation = lat == 0.0 || lon == 0.0 ? null : LatLng(lat, lon);

              notifyListeners();
            }
          },
          onError: (error) => print("Listen failed: $error"),
        );
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

  @override
  // ignore: must_call_super
  void dispose() {}
}
