import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/flight.dart';

import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/model/rocket.dart';


class LiveDataViewModel extends ChangeNotifier {
  final FlightViewModel _flightViewModel;
  int refreshRate = 1;
  LiveDataViewModel(this._flightViewModel){
    tryToConnect();
  }

  Flight? get currentFlight => _flightViewModel.currentFlight;
  bool get isConnected => _flightViewModel.isConnected;
  Rocket? currentRocket;

  void tryToConnect(){
    StreamSubscription subscription = Stream.empty().listen((event) {});
    var stream = Stream.periodic(Duration(seconds: refreshRate));
    subscription = stream.listen((event) { 
        print("Trying to connect... $isConnected");
        if (isConnected){
          print("i am conected");
          subscription.cancel();
          innitLiveData();
        }
    });
  }
  void innitLiveData(){
    print("init live data");
    print("is connected: $isConnected");
    if (isConnected){
      print("i am conected");
       Stream.periodic(Duration(seconds: refreshRate)).listen((event) { 
        currentRocket = _flightViewModel.fetchLastValue();
        notifyListeners();
      });
    }
  }
  Stream<bool> isConnectedStream(){
    return Stream<bool>.periodic(Duration(seconds: refreshRate), (x) => isConnected);
  }
  Stream<double> altitudeStream(){
    return Stream<double>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.altitude ?? 0.0);
  }
  Stream<double> altitudeGPSStream(){
    return Stream<double>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.altitudeGPS ?? 0.0);
  }
  Stream<double> verticalVelocityStream(){
    return Stream<double>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.verticalVelocity ?? 0.0);
  }
  Stream<Vector3> accelerationStream(){
    return Stream<Vector3>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.acceleration ?? Vector3(0,0,0));
  }
  Stream<Vector3> gyroscopeStream(){
    return Stream<Vector3>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.gyroscope ?? Vector3(0,0,0));
  }
  Stream<Vector3> velocityStream(){
    return Stream<Vector3>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.velocity ?? Vector3(0,0,0));
  }
  Stream<Geopoint> coordinatesStream(){
    return Stream<Geopoint>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.coordinates ?? Geopoint(0,0));
  }
  Stream<int> batteryStream(){
    return Stream<int>.periodic(Duration(seconds: refreshRate), (x) => currentRocket?.batteryLevel ?? 0);
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
