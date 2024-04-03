import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum rocketState {INIT, STANDBY, ASCENT, DESCENT, LANDING, RECOVERY}
class RocketViewModel extends ChangeNotifier {
  CollectionReference rocketCollection = FirebaseFirestore.instance.collection('flights'); //cant put null. Will be overriden
  Rocket? rocket;
  Flight? flight;

  void setupRocket(Flight? currentFlight){
    print(rocketCollection);
    flight = currentFlight;
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(flight?.uniqueId).collection('rocket');
    double? z = 0;
    rocket = Rocket(timestamp: DateTime.now(), altitude: 0, coordinates: Geopoint(z,z), acceleration: Vector3(z,z,z), velocity: Vector3(z,z,z), gyroscope: Vector3(z,z,z));
    sendData();
  } 
  void sendData(){
    rocketCollection.add(rocket!.toJson()).then((value) {
      rocket!.rocketID = value.id;
    });
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