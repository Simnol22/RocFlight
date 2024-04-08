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

enum rocketState { INIT, STANDBY, ASCENT, DESCENT, RECOVERY }
double FLIGHT_ALTITUDE_TRIGGER = 50.0;

class RocketViewModel extends ChangeNotifier {
  CollectionReference rocketCollection = FirebaseFirestore.instance.collection('flights');

  Timer? _periodicDataSenderTimer;
  Timer? _periodicFlightLoopTimer;
  Rocket rocket = Rocket();
  Flight? flight;
  DateTime? lastAccelTime;
  DateTime? lastPressTime;
  double? lastAltitude;

  //Calculating maximum values
  double? maxAltitude = 0.0;
  double? maxSpeed = 0.0;

  bool flightStarted = false;
  bool flightCalibrated = false;
  double groundAltitude = 0.0;
  
  var currentState = rocketState.INIT;
  
  void setupRocket(Flight? currentFlight) {
    flight = currentFlight;
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(flight?.uniqueId).collection('rocket');
    flightLoop(const Duration(milliseconds: 500)); //Check status every 500ms, might want to go faster in a real flight.
  }

  //Sends data to the DB
  void sendData() {
    rocket.timestamp = DateTime.now();
    rocketCollection.add(rocket.toJson()).then((value) {
      rocket.rocketID = value.id;
    });
  }

  // Calling this function activate the sensors, which will start feeding a rocket object with the current data
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
  //Send altitude data to the flight UI. Just to make sure the flight operator knows it's working
  Stream<double> getAltitudeStream(){
    return Stream<double>.periodic(const Duration(seconds: 1), (x) => rocket.altitude!);
  }
  
  //Flight loop, checks the status of the rocket every x milliseconds
  flightLoop(time){
    if (_periodicFlightLoopTimer != null){
      _periodicFlightLoopTimer?.cancel();
    }
    _periodicFlightLoopTimer = Timer.periodic(time, (timer) {
      verifyStatus();
    });
  }

  //Data loop, sends data to the DB every x milliseconds
  dataLoop(time){
    if (_periodicDataSenderTimer != null){
      _periodicDataSenderTimer?.cancel();
    }
    _periodicDataSenderTimer = Timer.periodic(time, (timer) {
      sendData();
    });
  }
  stopFlight() {
    _periodicFlightLoopTimer?.cancel();
    _periodicDataSenderTimer?.cancel();
  }


  // Altitude calculated with magic RockÉTS formula (NOAA Formula)
  // (pressure changed from hPa to Pa)
  void calculateAltitude(double pressure){  
    var altitude = 44307.693 - 4942.781 * pow((pressure*100), 0.190284);
    rocket.altitude = altitude;
  }

  // Calculating velocity with acceleration * time
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

  void calibrateRocket(){
    if (rocket.altitude != null && !flightCalibrated){
      groundAltitude = rocket.altitude!;
      flightCalibrated = true;
    }
  }

  void verifyStatus() {
      switch(currentState){
        case rocketState.INIT: //initialisation
          calibrateRocket();
          if (flightStarted && flightCalibrated){
            dataLoop(const Duration(seconds: 2));
            currentState = rocketState.STANDBY;
          }
          break;
        case rocketState.STANDBY: //Standby
          if ((rocket.altitude! - groundAltitude) > FLIGHT_ALTITUDE_TRIGGER){ //Launch detected :) 
            currentState = rocketState.ASCENT;
            dataLoop(const Duration(seconds: 1));
          }
          break;
        case rocketState.ASCENT: // Ascent
          if (rocket.verticalVelocity! < 0){ // Vitesse négative -> apogée
            currentState = rocketState.DESCENT;
          }
          break;
        case rocketState.DESCENT: // Descent
          if (rocket.verticalVelocity! >= 0){ // Vitesse n'est plus négative -> atterissage
            currentState = rocketState.RECOVERY;
            dataLoop(const Duration(seconds: 5)); // Diminuer le taux d'envoi de données
          }          
          break;
        case rocketState.RECOVERY: // Recovery
            // Might implement something in the future, but for now do nothing. Wait for rocketeer to retrieve rocket
          break;
        default:
          currentState = rocketState.INIT;
          break;
      }
    }
}