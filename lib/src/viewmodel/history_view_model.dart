import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:roc_flight/src/services/storage_service.dart';
import 'package:roc_flight/src/model/flight.dart';

class HistoryViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  CollectionReference collection =
      FirebaseFirestore.instance.collection('flights');
  List<Flight> flightHistory = [];

  void fetchFlightHistory() {
    collection
        //.where('operatorIds', arrayContains: _storageService.getUserId())
        .where('status', isEqualTo: FlightStatus.ended.index)
        .get()
        .then((value) {
      flightHistory =
          value.docs.map((e) => Flight.fromFirestore(e.id, e.data())).toList();
      notifyListeners();
    });
  }

  Future<Rocket?> fetchLastRocketSnapshot(String flightCode) async {
    try {
      final snapshot = await collection
          .doc(flightCode)
          .collection("rocket")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Rocket.fromFirestore(
            snapshot.docs.first.id, snapshot.docs.first.data());
      }
    } catch (e) {
      print("Error fetching last rocket snapshot: $e");
      return null;
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
