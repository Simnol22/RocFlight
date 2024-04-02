import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/flight.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roc_flight/src/services/sensors.dart';
import 'package:roc_flight/src/storage_service.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:roc_flight/src/viewmodel/rocket_view_model.dart';

class FlightViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('flights');
  // Represent the current active flight (regardless of the user mode)
  Flight? flight;

  // Get the current flight
  Flight? get currentFlight => flight;

  String launcherUid = '';
  RocketViewModel? rocketViewModel;
  bool isFlightStarted = false;
  void createFlight() {
    fetchlauncherUid().then((value) {
      launcherUid = value;
      if (launcherUid.isEmpty) {
        throw Exception('Error setting launcherUid');
      }
    });

    Flight entry = Flight(
        createdAt: DateTime.now(),
        status: FlightStatus.created,
        launcherId: launcherUid,
        operatorIds: []);

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
  }

  void startFlight() {
    rocketViewModel = RocketViewModel();
    if (flight != null) {
      flight?.status = FlightStatus.started;
      collection
          .doc(flight?.uniqueId)
          .set(flight?.toFirestoreMap(), SetOptions(merge: true))
          .then((value) => notifyListeners());
    }
    while (flight?.status == FlightStatus.started || flight?.status == FlightStatus.ongoing	) {
      print("flight running");
    }
    while (flight?.status == FlightStatus.started || flight?.status == FlightStatus.ongoing	) {
      print("flight running");
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
      });
    }
    print("Ending flight");
  }

  void _listenToFlightUpdates(String? documentId) {
    if (documentId?.isNotEmpty ?? false) {
      final ref = collection.doc(documentId);

      ref.snapshots().listen(
        (event) {
          // Reflect changes
          print("${event.data()}");
        },
        onError: (error) => print("Listen failed: $error"),
      );
    }
  }

  Future<String> fetchlauncherUid() async {
    final userId = await _storageService.getUserId();
    if (userId.isEmpty) {
      var uuid = Uuid();
      var randomId = uuid.v1();
      await _storageService.setUserId(randomId);
      print("No userID, creating random one: $randomId");
      return randomId;
    }
    return userId;
  }

  bool connectToFlightByCode(String code) {
    print("Connecting to flight with code: $code");
    code = code.substring(0, code.length.clamp(0, 6)).toUpperCase();

    collection
        .where('code', isEqualTo: code)
        .where('status', isNotEqualTo: FlightStatus.ongoing.index)
        .limit(1)
        .get()
        .then((snapshot) {
      flight = (snapshot.size > 0)
          ? Flight.fromFirestore(snapshot.docs[0].id, snapshot.docs[0].data())
          : null;
      if (flight != null) {
        //Connected to flight
        print("Connected to flight with code: $code");
        _listenToFlightUpdates(flight?.uniqueId);
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
          fontSize: 16.0);
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      print(error);
    });

    return false;
  }
}
