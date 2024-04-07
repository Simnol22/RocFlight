import 'dart:async';

import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/services/sensors.dart';
import 'package:roc_flight/src/services/location_service.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'dart:math';
import 'dart:io';

enum rocketState { INIT, STANDBY, ASCENT, DESCENT, LANDING, RECOVERY }

class RocketViewModel extends ChangeNotifier {
  CollectionReference rocketCollection = FirebaseFirestore.instance.collection('flights');

  Timer? _periodicDataSenderTimer;

  Rocket rocket = Rocket();
  Flight? flight;
  DateTime? lastAccelTime;
  DateTime? lastPressTime;
  double? lastAltitude;

  //Calculating maximum values
  double? maxAltitude = 0.0;
  double? maxSpeed = 0.0;

  bool sendingData = false;

  double accelXFiltered = 0.0;
  double accelYFiltered = 0.0;
  double accelZFiltered = 0.0;

  double gravity_x = 0.0;
  double gravity_y = 0.0;
  double gravity_z = 0.0;

  double alpha = 0.8;
  
  void setupRocket(Flight? currentFlight) {
    flight = currentFlight;
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(flight?.uniqueId).collection('rocket');
    rocket.coordinates = Geopoint(0.0, 0.0); //For testing fetching location
    saveDataToDB();
  }

  void sendData() {
    rocket.timestamp = DateTime.now();
    rocketCollection.add(rocket.toJson()).then((value) {
      rocket.rocketID = value.id;
    });
    print("rocket sent !");
  }

   void activateSensors(){
    print("activating sensors");
    SensorService sensorService = SensorService();
    LocationService locationService = LocationService();
    
    sensorService.getAccelerometerStream()?.listen((event) {
      rocket.acceleration = Vector3(event.x, event.y, event.z);
      rocket.timestamp = DateTime.now();
      calculateVelocity(rocket.timestamp);
      lastAccelTime = rocket.timestamp;
    });
    
    sensorService.getGyroscopeStream()?.listen((event) {
      rocket.gyroscope = Vector3(event.x, event.y, event.z);
    });

    sensorService.getPressureStream()?.listen((event) {
      rocket.timestamp = DateTime.now();
      calculateAltitude(event);
      calculateVerticalVelocity(rocket.timestamp);
      lastPressTime = rocket.timestamp;
      lastAltitude = rocket.altitude;
      if (rocket.altitude! > maxAltitude!) {
        maxAltitude = rocket.altitude;
        rocket.maxAltitude = maxAltitude;
      }
    });
    //Make sure you get permission
    locationService.checkAndRequestLocationPermissions().then((value) => 
    locationService.getGPSStream()?.listen((event) {
      rocket.coordinates = Geopoint(event.latitude, event.longitude);
      rocket.altitudeGPS = event.altitude;
      rocket.GPSVelocity = event.speed;
    }));
    Stream.periodic(const Duration(seconds: 10)).listen((event) { 
      BatteryInfoPlugin().androidBatteryInfo.then((value) {
        rocket.batteryLevel = value?.batteryLevel;
      });
    });
  }

  Stream<double> getAltitudeStream(){
    return Stream<double>.periodic(Duration(seconds: 1), (x) => rocket.altitude!);
  }

 saveDataToDB() {
    _periodicDataSenderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if(sendingData){
        sendData();
      }
    });
  }

  stopFlight() {
    _periodicDataSenderTimer?.cancel();
  }


  // Altitude calculated with magic RockÉTS formula (NOAA Formula)
  // (pressure changed from hPa to Pa)
  void calculateAltitude(double pressure){  
    var altitude = 44307.693 - 4942.781 * pow((pressure*100), 0.190284);
    rocket.altitude = altitude;
  }

  // À VÉRIFIER SVP ! SUS ! 
  void calculateVelocity(time){
    if(lastAccelTime != null){
      var deltaT = time.difference(lastAccelTime).inMicroseconds / Duration.microsecondsPerSecond;
      rocket.velocity ??= Vector3(0, 0, 0);
      rocket.velocity!.x += rocket.acceleration!.x * deltaT;
      rocket.velocity!.y += rocket.acceleration!.y * deltaT;
      rocket.velocity!.z += rocket.acceleration!.z * deltaT;
    }
  }

  //More reliable speed :)
  void calculateVerticalVelocity(time){
    if(lastPressTime != null && lastAltitude != null){
      var deltaT = time.difference(lastPressTime).inMicroseconds / Duration.microsecondsPerSecond;
      rocket.verticalVelocity = (rocket.altitude! - lastAltitude!)*deltaT;
      if(rocket.verticalVelocity! > maxSpeed!){
        maxSpeed = rocket.verticalVelocity;
        rocket.maxSpeed = maxSpeed;
      }
    }
  }

  void runFlight() {
    var currentState = rocketState.INIT;
    while(true){
      switch(currentState){
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