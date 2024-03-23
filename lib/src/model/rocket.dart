class Rocket {
  final String rocketId;
  final double latitude;
  final double longitude;
  // Add more properties (altitude, speed, etc.)

  Rocket(
      {required this.rocketId,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'rocketId': rocketId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Rocket.fromMap(Map<String, dynamic> map) {
    return Rocket(
      rocketId: map['rocketId'] ?? '', // Assuming 'rocketId' is always present
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }
}
