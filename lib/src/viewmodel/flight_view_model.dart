import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/flight.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roc_flight/src/services/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:roc_flight/src/viewmodel/rocket_view_model.dart';

class FlightViewModel extends ChangeNotifier {
  // Singleton instancing
  static final FlightViewModel _instance = FlightViewModel._internal();
  factory FlightViewModel() => _instance;
  FlightViewModel._internal();
  //

  final StorageService _storageService = StorageService();
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  
  Flight? flight; // Represent the current active flight (regardless of the user mode)
  RocketViewModel? rocketViewModel; // Represent the current active rocket

  bool connected = false;
  // Get the current flight
  Flight? get currentFlight => flight;

  bool get hasAnyFlight => (flight != null && flight!.uniqueId!.isNotEmpty && flight!.isActive);

  // Get the current rocket
  RocketViewModel? get currentRocket => rocketViewModel;

  void startPeriodicRocketDataSender() {
    rocketViewModel = RocketViewModel();
    rocketViewModel?.activateSensors();
    rocketViewModel?.setupRocket(flight!);
  }

  void createFlight() {
    fetchlauncherUid().then((launcherId) {
      
      Flight entry = Flight(
        createdAt: DateTime.now(), 
        status: FlightStatus.created, 
        launcherId: launcherId, 
        operatorIds: []
      );

      collection.add(entry.toFirestoreMap()).then((value) {
        entry.uniqueId = value.id;
        entry.code = entry.uniqueId?.substring(0, 6).toUpperCase();

      collection
        .doc(entry.uniqueId)
        .set(entry.toFirestoreMap(), SetOptions(merge: true))
        .then((value) {
          flight = entry;
          notifyListeners();
        });
    }).catchError((error) {
      print(error);
    });
    });
  }

  void startFlight() {
    print("Starting flight");

    rocketViewModel = RocketViewModel();
    if (flight != null) {
      flight?.status = FlightStatus.started;

      collection
        .doc(flight?.uniqueId)
        .set(flight?.toFirestoreMap(), SetOptions(merge: true))
        .then((value) {
          startPeriodicRocketDataSender();
          notifyListeners();
        });
    }
  }

  void endFlight() {
    if (flight != null) {
      flight?.status = FlightStatus.ended;

      collection
        .doc(flight?.uniqueId)
        .set(flight?.toFirestoreMap(), SetOptions(merge: true))
        .then((value) {
          flight = null;
          notifyListeners();
          rocketViewModel?.stopFlight();
        });
    }
    print("Ending flight");
  }

  Future<String> fetchlauncherUid() async {
    final userId = await _storageService.getUserId();
    if (userId.isEmpty) {
      var id = const Uuid().v1();
      await _storageService.setUserId(const Uuid().v1());
      print("No userID, creating random one: $id");
      return id;
    }
    return userId;
  }

  bool connectToFlightByCode(String code) {
    print("Connecting to flight with code: $code");
    code = code.substring(0, code.length.clamp(0, 6)).toUpperCase();

    collection
      .where('code', isEqualTo: code)
      .where('status', isNotEqualTo: FlightStatus.ended.index)
      .limit(1)
      .get()
      .then((snapshot) {
        flight = (snapshot.size > 0)
          ? Flight.fromFirestore(snapshot.docs[0].id, snapshot.docs[0].data())
          : null;

        if (flight != null) {
          _addMyselfAsFlightOperator();
          notifyListeners();
          return true;
        }
        //Flight not found
        Fluttertoast.showToast(
          msg: "Flight not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
        );
        // ignore: body_might_complete_normally_catch_error
      }).catchError((error) {
        print(error);
      });

    return false;
  }

  bool disconnectFromFlight() {
    if (flight != null) {
      flight = null;
      notifyListeners();
      rocketViewModel?.stopFlight();
    }
    return true;
  }

  Future<bool?> amITheFlightLauncher() async {
    var id = await fetchlauncherUid();

    if (flight == null) { return null; }

    return (flight != null && flight?.launcherId == id);
  }

  Future _addMyselfAsFlightOperator() async {
    flight?.operatorIds.add(await fetchlauncherUid());

    collection
      .doc(flight?.uniqueId)
      .set(flight?.toFirestoreMap(), SetOptions(merge: true))
      .then((value) {
        notifyListeners();
      });
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}