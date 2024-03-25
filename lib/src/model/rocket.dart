import 'dart:convert';

class Rocket {
  String? rocketID;
  int? altitude;
  Geopoint? coordinates;
  Vector3? acceleration;
  Vector3? gyroscope;
  Vector3? velocity;

  Rocket({this.rocketID, this.altitude, this.coordinates, this.acceleration, this.gyroscope, this.velocity});

  Rocket.fromJson(Map<String, dynamic> json) {
    rocketID = json['rocketID'];
    altitude = json['altitude'];
    coordinates = json['coordinates'] != null ? Geopoint.fromJson(json['Geopoint']) : null;
    acceleration = json['acceleration'] != null ? Vector3.fromMap(json['acceleration']) : null;
    gyroscope = json['gyroscope'] != null ? Vector3.fromMap(json['gyroscope']) : null;
    velocity = json['velocity'] != null ? Vector3.fromMap(json['velocity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rocketID'] = rocketID;
    data['altitude'] = altitude;
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

    return data;
  }
}

class Geopoint {
  double? latitude;
  double? longitude;

  Geopoint({this.latitude, this.longitude});

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
