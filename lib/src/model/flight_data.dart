class FlightData {
  String uniqueId;
  DateTime timestamp;
  double altitude;
  Coordinates phoneCoordinates;
  Coordinates rocketCoordinates;
  double distance;
  double velocity;
  double acceleration;
  Gyroscope gyroscope;

  FlightData({
    required this.uniqueId,
    required this.timestamp,
    required this.altitude,
    required this.phoneCoordinates,
    required this.rocketCoordinates,
    required this.distance,
    required this.velocity,
    required this.acceleration,
    required this.gyroscope,
  });
}

class Coordinates {
  double latitude;
  double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });
}

class Gyroscope {
  double x;
  double y;
  double z;

  Gyroscope({
    required this.x,
    required this.y,
    required this.z,
  });
}
