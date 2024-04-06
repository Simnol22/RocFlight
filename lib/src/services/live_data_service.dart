import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LiveDataService { // Singleton for transfering flight data between all viewModels
  static final LiveDataService _liveDataService = LiveDataService._internal();
  Flight? flight;
  bool isConnected = false;
  CollectionReference collection = FirebaseFirestore.instance.collection('flights');
  CollectionReference? rocketCollection;

  bool get isFlightConnected => isConnected;

  factory LiveDataService() {
    return _liveDataService;
  }

  LiveDataService._internal();

  void connect(Flight flight) {
    this.flight = flight;
    isConnected = true;
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(_liveDataService.flight?.uniqueId).collection('rocket');
  }

  Rocket? fetchLastVal(){
    rocketCollection = FirebaseFirestore.instance.collection('flights').doc(_liveDataService.flight?.uniqueId).collection('rocket');
    if (flight != null && rocketCollection != null) {
      rocketCollection?.orderBy('timestamp', descending: true).limit(1).get().then((value) {
        if (value.docs.isNotEmpty) {
          return Rocket.fromJson(value.docs[0].data() as Map<String, dynamic>?);
        }
      });
      
    }
    return null;
  }
}