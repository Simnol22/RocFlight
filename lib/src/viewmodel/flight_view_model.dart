import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/flight.dart';

class FlightViewModel extends ChangeNotifier {
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  // Represent the current active flight (regardless of the user mode)
  Flight? flight;

  void createFlight() {
    Flight entry = Flight(
      createdAt: DateTime.now(),
      status: FlightStatus.created,
      launcherId: 'users/ltKvmB5neCT5a2BPC8rO', // TODO should be the current user
      operatorIds: []
    );

    collection
      .add(entry.toFirestoreMap())
      .then((value) { 
        entry.uniqueId = value.id;
        entry.code = entry.uniqueId?.substring(0, 6).toUpperCase();

        collection
          .doc(entry.uniqueId)
          .set(entry.toFirestoreMap(), SetOptions(merge: true))
          .then((value) {
            flight = entry;
            notifyListeners();
          });
      })
      .catchError((error) { print(error); });
  }

  void startFlight() {
    if (flight != null) {
      flight?.status = FlightStatus.started;

      collection
        .doc(flight?.uniqueId)
        .set(flight?.toFirestoreMap(), SetOptions(merge: true))
        .then((value) => notifyListeners());
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
  }

  void _listenToFlightUpdates(String? documentId) {
    if (documentId?.isNotEmpty??false) {
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

  bool connectToFlightByCode(String code) {
    code = code.substring(0, code.length.clamp(0, 6)).toUpperCase();

    collection
      .where('code', isEqualTo: code)
      .where('status', isNotEqualTo: FlightStatus.ongoing.index)
      .limit(1)
      .get()
      .then((snapshot) {
        flight = (snapshot.size > 0) ? Flight.fromFirestore(snapshot.docs[0].id, snapshot.docs[0].data()) : null;
        
        _listenToFlightUpdates(flight?.uniqueId);

        notifyListeners();
      })
      .catchError((error) { print(error); });

    return false;
  }
}