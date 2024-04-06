import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/flight.dart';

import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/model/rocket.dart';

class LiveDataViewModel extends ChangeNotifier {
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  late final FlightViewModel _flightViewModel;
  int refreshRate = 1;
  bool get hasAnyFlight => _flightViewModel.hasAnyFlight;

  LiveDataViewModel(FlightViewModel flightViewModel) {
    _flightViewModel = flightViewModel;
    if (hasAnyFlight) {
      _listenToFlightUpdates(_flightViewModel.currentFlight!.uniqueId);
    }
  }

  Flight? get currentFlight => _flightViewModel.currentFlight;

  RocketComparator rocketComparator = RocketComparator();
  Rocket? previousRocket;
  Rocket? currentRocket;

  void _listenToFlightUpdates(String? documentId) {
    if (documentId?.isNotEmpty ?? false) {
      final ref = collection.doc(documentId).collection("rocket");

      ref
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .listen(
          (snapshot) {
            final rocket = (snapshot.size > 0) 
              ? Rocket.fromFirestore(snapshot.docs[0].id, snapshot.docs[0].data())
              : null;

            previousRocket = currentRocket;

            if (rocket != null) {
              currentRocket = rocket;
              notifyListeners();
            }
          },
          onError: (error) => print("Listen failed: $error"),
        );
    }
  }

  bool get isConnected {
    return hasAnyFlight;
  }

  String get status {
    return 'Launched';
  }

  Vector3 get gyroscope => currentRocket?.gyroscope ?? Vector3(0,0,0);
  Geopoint get coordinates => currentRocket?.coordinates ?? Geopoint(0,0);
  Vector3 get acceleration => currentRocket?.acceleration ?? Vector3(0,0,0);

  int get batteryLevel => currentRocket?.batteryLevel ?? 0;

  double get altitude => currentRocket?.altitude ?? 0.0;
  double get altitudeGPS => currentRocket?.altitudeGPS ?? 0.0;

  Vector3 get velocity => currentRocket?.velocity ?? Vector3(0,0,0);
  double get verticalVelocity => currentRocket?.verticalVelocity ?? 0.0;

  double get mockCurrentRollRate => 20;
  double get mockApogeeAltitude => 10000;
  double get mockMaxRollRate => 30;
  double get mockMaxVelocity => 200;
  double get mockMaxAcceleration => 20;

  // Used for UI animations
  bool isValueDifferent<T>(T? Function(Rocket) attributeGetter) {
    rocketComparator.previousRocket = previousRocket;
    rocketComparator.currentRocket = currentRocket;
    return rocketComparator.compareAttribute(attributeGetter);
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}