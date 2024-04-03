import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/flight.dart';

import 'package:roc_flight/src/viewmodel/flight_view_model.dart';

class LiveDataViewModel extends ChangeNotifier {
  final BuildContext context;

  LiveDataViewModel(this.context);

  Flight? getFlight() {
    FlightViewModel flightViewModel =
        Provider.of<FlightViewModel>(context, listen: false);
    return flightViewModel.flight;
  }

  bool get mockIsConnected {
    return true;
  }

  String get  mockRocketStatus {
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

  int get mockBatteryLevel {
    return 80;
  }
}
