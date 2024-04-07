import 'package:cloud_firestore/cloud_firestore.dart';

class Rocket {
  String? rocketID;
  double? altitude;
  double? altitudeGPS;
  Geopoint? coordinates;
  Vector3? acceleration;
  Vector3? gyroscope;
  Vector3? velocity;
  double? verticalVelocity;
  double? GPSVelocity;
  int? batteryLevel;
  double? maxAltitude;
  double? maxSpeed;
  DateTime? timestamp;
 

  Rocket(
      {this.rocketID,
      this.altitude,
      this.altitudeGPS,
      this.coordinates,
      this.acceleration,
      this.gyroscope,
      this.velocity,
      this.verticalVelocity,
      this.GPSVelocity,
      this.batteryLevel,
      this.maxAltitude,
      this.maxSpeed,
      this.timestamp});

  static Rocket fromFirestore(String id, Object? raw) {
    Map<String, dynamic> data = raw as Map<String, dynamic>;

    return Rocket(
      rocketID: id,
      altitude: data['altitude'],
      altitudeGPS: data['altitudeGPS'],
      coordinates: data['coordinates'] != null ? Geopoint.fromJson(data['coordinates']) : null,
      acceleration: data['acceleration'] != null ? Vector3.fromMap(data['acceleration']) : null,
      gyroscope: data['gyroscope'] != null ? Vector3.fromMap(data['gyroscope']) : null,
      velocity: data['velocity'] != null ? Vector3.fromMap(data['velocity']) : null,
      verticalVelocity: data['verticalVelocity'],
      GPSVelocity: data['GPSVelocity'],
      batteryLevel: data['batteryLevel'],
      maxAltitude: data['maxAltitude'],
      maxSpeed: data['maxSpeed'],
      timestamp: (data['timestamp'] as Timestamp).toDate()
    );
  }

  Rocket.fromJson(Map<String, dynamic>? json) {
    rocketID = json?['rocketID'];
    altitude = json?['altitude'];
    altitudeGPS = json?['altitudeGPS'];  
    coordinates = json?['coordinates'] != null
        ? Geopoint.fromJson(json?['coordinates'])
        : null;
    acceleration = json?['acceleration'] != null
        ? Vector3.fromMap(json?['acceleration'])
        : null;
    gyroscope =
        json?['gyroscope'] != null ? Vector3.fromMap(json?['gyroscope']) : null;
    velocity =
        json?['velocity'] != null ? Vector3.fromMap(json?['velocity']) : null;
    verticalVelocity = json?['verticalVelocity'];
    GPSVelocity = json?['GPSVelocity'];
    batteryLevel = json?['batteryLevel'];
    maxAltitude = json?['maxAltitude'];
    maxSpeed = json?['maxSpeed'];
    timestamp = (json?['timestamp'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['altitude'] = altitude;
    data['altitudeGPS'] = altitudeGPS;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    if (acceleration != null) {
      data['acceleration'] = acceleration!.toMap();
    }
    if (gyroscope != null) {
      data['gyroscope'] = gyroscope!.toMap();
    }
    if (velocity != null) {
      data['velocity'] = velocity!.toMap();
    }
    data['verticalVelocity'] = verticalVelocity;
    data['GPSVelocity'] = GPSVelocity;
    data['batteryLevel'] = batteryLevel;
    data['maxAltitude'] = maxAltitude;
    data['maxSpeed'] = maxSpeed;
    data['timestamp'] = timestamp;

    return data;
  }
}

class Geopoint {
  double? latitude;
  double? longitude;

  Geopoint(this.latitude, this.longitude);

  Geopoint.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Vector3 {
  double x;
  double y;
  double z;

  Vector3(this.x, this.y, this.z);

  // Convert a Vector3 instance to a map
  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
    };
  }

  // Convert a map to a Vector3 instance
  static Vector3 fromMap(Map<String, dynamic> map) {
    return Vector3(
      map['x'],
      map['y'],
      map['z'],
    );
  }
}

class RocketComparator {
  Rocket? previousRocket;
  Rocket? currentRocket;

  bool compareAttribute<T>(T? Function(Rocket) attributeGetter) {
    final T? previousValue = previousRocket != null ? attributeGetter(previousRocket!) : null;
    final T? currentValue = currentRocket != null ? attributeGetter(currentRocket!) : null;

    return previousValue != currentValue;
  }
}