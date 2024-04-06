import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/services/sensors.dart';
import 'package:roc_flight/src/services/location_service.dart';
import 'dart:math';
import 'dart:io';

enum rocketState { INIT, STANDBY, ASCENT, DESCENT, LANDING, RECOVERY }

class RocketViewModel extends ChangeNotifier {
  CollectionReference rocketCollection =
      FirebaseFirestore.instance.collection('flights'); //cant put null. Will be overriden
  Rocket rocket = Rocket();
  Flight? flight;
  DateTime? lastAccelTime;
  DateTime? lastPressTime;
  double? lastAltitude;

  double accelXFiltered = 0.0;
  double accelYFiltered = 0.0;
  double accelZFiltered = 0.0;

  double gravity_x = 0.0;
  double gravity_y = 0.0;
  double gravity_z = 0.0;

  double alpha = 0.8;

  void setupRocket(Flight? currentFlight) {
    print(rocketCollection);
    flight = currentFlight;
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(flight?.uniqueId).collection('rocket');
    rocket.coordinates = Geopoint(0.0, 0.0); //For testing fetching location
    saveDataToDB();
  }

  void sendData() {
    rocketCollection.add(rocket.toJson()).then((value) {
      rocket.rocketID = value.id;
    });
    print("rocket sent !");
  }

  void activateSensors() {
    print("activating sensors");
    SensorService sensorService = SensorService();
    LocationService locationService = LocationService();

    sensorService.getAccelerometerStream()?.listen((event) {
      rocket.acceleration = Vector3(event.x, event.y, event.z);
      lastAccelTime = rocket.timestamp;
      rocket.timestamp = DateTime.now();

      // Correct acceleration data with gravity
      gravity_x = alpha * gravity_x + (1 - alpha) * rocket.acceleration!.x;
      gravity_y = alpha * gravity_y + (1 - alpha) * rocket.acceleration!.y;
      gravity_z = alpha * gravity_z + (1 - alpha) * rocket.acceleration!.z;

      Vector3 linearAcceleration = Vector3(
        rocket.acceleration!.x - gravity_x,
        rocket.acceleration!.y - gravity_y,
        rocket.acceleration!.z - gravity_z,
      );
      rocket.acceleration = linearAcceleration;
      print("acceleration : $linearAcceleration");

      calculateVelocity(rocket.timestamp, linearAcceleration);
    });

    sensorService.getGyroscopeStream()?.listen((event) {
      rocket.gyroscope = Vector3(event.x, event.y, event.z);
    });

    sensorService.getPressureStream()?.listen((event) {
      rocket.timestamp = DateTime.now();
      calculateAltitude(event);
      lastPressTime = rocket.timestamp;
      lastAltitude = rocket.altitude;
    });
    //Make sure you
    locationService
        .checkAndRequestLocationPermissions()
        .then((value) => locationService.getGPSStream()?.listen((event) {
              rocket.coordinates = Geopoint(event.latitude, event.longitude);
              rocket.altitudeGPS = event.altitude;
            }));
  }

  Stream<double> getAltitudeStream() {
    return Stream<double>.periodic(Duration(seconds: 1), (x) => rocket.altitude!);
  }

  Stream<Vector3> getAccelerationStream() {
    return Stream<Vector3>.periodic(Duration(milliseconds: 10), (x) => rocket.acceleration!);
  }

  Stream<Vector3> getGyroscopeStream() {
    return Stream<Vector3>.periodic(Duration(seconds: 1), (x) => rocket.gyroscope!);
  }

  Stream<Vector3> getVelocityStream() {
    return Stream<Vector3>.periodic(Duration(milliseconds: 10), (x) => rocket.velocity!);
  }

  saveDateToDB() {
    Stream.periodic(Duration(seconds: 3)).listen((event) {
      //sendData();
    });
  }

  // Altitude calculated with magic RockÉTS formula (NOAA Formula)
  // (pressure changed from hPa to Pa)
  void calculateAltitude(double pressure) {
    var altitude = 44307.693 - 4942.781 * pow((pressure * 100), 0.190284);
    rocket.altitude = altitude;
  }

  void calculateVelocity(DateTime? time, Vector3 accel) {
    double s = 0.75;
    double dt = time!.difference(lastAccelTime!).inMilliseconds.toDouble();

    // Filter acceleration data
    accelXFiltered = accelXFiltered * s + accel.x * (1 - s);
    accelYFiltered = accelYFiltered * s + accel.y * (1 - s);
    accelZFiltered = accelZFiltered * s + accel.z * (1 - s);

    print("filtered acceleration : $accelXFiltered, $accelYFiltered, $accelZFiltered");

    // Initialize rocket.velocity if it's null
    rocket.velocity = rocket.velocity ?? Vector3(0.0, 0.0, 0.0);

    // Integrate just using a Reimann sum
    rocket.velocity?.x += accelXFiltered * dt;
    rocket.velocity?.y += accelYFiltered * dt;
    rocket.velocity?.z += accelZFiltered * dt;

    print("dt : $dt");
    print("velocity : ${rocket.velocity?.x}, ${rocket.velocity?.y}, ${rocket.velocity?.z}");
  }

  void runFlight() {
    var currentState = rocketState.INIT;
    while (true) {
      switch (currentState) {
        case rocketState.INIT: //initialisation
          //Calibration and stuff
          break;
        case rocketState.STANDBY: //Standby
          //Calibration terminated, verify if launch detected

          break;
        case rocketState.ASCENT: // Ascent
          //Altitude climbing, check for apogee and modify senging rate
          break;
        case rocketState.DESCENT: // Descent
          //Apogee reached, altitude decreasing, check for landing
          break;
        case rocketState.LANDING: // Landing
          //Altitude decreasing, check for landing
          break;
        case rocketState.RECOVERY: // Recovery
          //Landing detected, modify sending rate
          break;
        default:
          break;
      }
    }
  }
}
