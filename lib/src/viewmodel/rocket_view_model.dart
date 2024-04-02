import 'package:roc_flight/src/model/rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum rocketState {INIT, STANDBY, ASCENT, DESCENT, LANDING, RECOVERY}
class RocketViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rocket? rocket;
  
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