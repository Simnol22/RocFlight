import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/flight.dart';

import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/model/rocket.dart';

class LiveDataViewModel extends ChangeNotifier {
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  late final FlightViewModel _flightViewModel;

  LiveDataViewModel(FlightViewModel flightViewModel) {
    rocketBuffer = [];
    _flightViewModel = flightViewModel;
    if (hasAnyFlight) {
      _listenToFlightUpdates(_flightViewModel.currentFlight!.uniqueId);
    }
  }

  Flight? get currentFlight => _flightViewModel.currentFlight;
  bool get hasAnyFlight => _flightViewModel.hasAnyFlight;

  final RocketComparator rocketComparator = RocketComparator();

  List<Rocket> rocketBuffer = [];
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

              rocketBuffer.add(currentRocket!);
              if (rocketBuffer.length > 5) { rocketBuffer.removeAt(0); }

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

  double get mockCurrentRollRate => 0;
  double get mockApogeeAltitude => 0;
  double get mockMaxRollRate => 0;
  double get mockMaxVelocity => 0;
  double get mockMaxAcceleration => 0;

  // Used for UI animations
  bool isValueDifferent<T>(T? Function(Rocket) attributeGetter) {
    rocketComparator.previousRocket = previousRocket;
    rocketComparator.currentRocket = currentRocket;
    return rocketComparator.compareAttribute(attributeGetter);
  }

  List<double> get altitudeBuffer => rocketBuffer.map((r) => r.altitude??0.0).toList();
  List<double> get altitudeGPSBuffer => rocketBuffer.map((r) => r.altitudeGPS??0.0).toList();

  List<double> get accelerationXBuffer => rocketBuffer.map((r) => r.acceleration?.x??0.0).toList();
  List<double> get accelerationYBuffer => rocketBuffer.map((r) => r.acceleration?.y??0.0).toList();
  List<double> get accelerationZBuffer => rocketBuffer.map((r) => r.acceleration?.z??0.0).toList();

  @override
  // ignore: must_call_super
  void dispose() {}
}