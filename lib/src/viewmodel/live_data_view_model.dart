import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/flight.dart';

import 'package:roc_flight/src/model/rocket.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';

class LiveDataViewModel extends ChangeNotifier {
  final BuildContext context;

  LiveDataViewModel(this.context);

  Flight? getFlight() {
    FlightViewModel flightViewModel = Provider.of<FlightViewModel>(context, listen: false);
    return flightViewModel.flight;
  }

  List<double> getMockAltitudeData() {
    const double maxAltitude = 10000;
    const double g = 9.8;
    final double v0 = sqrt(maxAltitude * 2 * g);
    const int numDataPoints = 100;
    final double totalTime = 2 * v0 / g;
    final double timeIncrement = totalTime / numDataPoints;

    return List<double>.generate(numDataPoints, (index) {
      double t = index * timeIncrement;
      return v0 * t - 0.5 * g * t * t;
    });
  }

  List<double> getMockVelocityData() {
    return List<double>.generate(50, (index) => (index * 5).toDouble());
  }

  List<double> getMockAccelerationData() {
    return List<double>.generate(50, (index) => (index * 2).toDouble());
  }

  List<double> getMockAngularVelocityData() {
    return List<double>.generate(50, (index) => (index * 3).toDouble());
  }

  bool get mockIsConnected {
    return true;
  }

  String get mockRocketStatus {
    return 'Launched';
  }

  double get mockApogeeAltitude {
    return 10000;
  }

  double get mockCurrentAltitude {
    return 5000;
  }

  double get mockCurrentVelocity {
    return 100;
  }

  double get mockCurrentAcceleration {
    return 10;
  }

  double get mockCurrentRollRate {
    return 20;
  }

  double get mockMaxRollRate {
    return 30;
  }

  double get mockMaxVelocity {
    return 200;
  }

  double get mockMaxAcceleration {
    return 20;
  }
}
