import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  // ignore: must_call_super
  void dispose() {}
}
