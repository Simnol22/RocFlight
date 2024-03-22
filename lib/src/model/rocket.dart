class Rocket {
  final double latitude;
  final double longitude;

  Rocket({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Rocket.fromMap(Map<String, dynamic> map) {
    return Rocket(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }
}
