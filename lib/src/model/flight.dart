import 'package:cloud_firestore/cloud_firestore.dart';

enum FlightStatus { 
  created, // 0
  started, // 1
  ongoing, // 2
  ended // 3
}

class Flight {
  String? uniqueId;
  String? code;
  DateTime createdAt;
  FlightStatus status;
  String launcherId;
  List<String> operatorIds;

  Flight({
    this.uniqueId,
    this.code,
    this.status = FlightStatus.created,
    required this.createdAt,
    required this.launcherId,
    required this.operatorIds
  });

  String get flightCode => code??"NO CODE";

  bool get isActive => status != FlightStatus.ended;
  bool get iStarted => status == FlightStatus.started || status == FlightStatus.ongoing;

  bool get amILauncher => true; // launcherId == ""; TODO check current user Id

  static Flight fromFirestore(String id, Object? raw) {
    Map<String, dynamic> data = raw as Map<String, dynamic>;

    return Flight(
      uniqueId: id,
      code: data['code'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      launcherId: data['launcherId'] ?? '',
      status: (FlightStatus.values[data['status']]),
      operatorIds: [],
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'code': code,
      'status': status.index,
      'createdAt': createdAt,
      'launcher': launcherId,
      'operatorIds': operatorIds,
    };
  }
}