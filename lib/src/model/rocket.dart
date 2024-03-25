class Rocket {
  int? rocketID;
  int? altitude;
  Geopoint? coordinates;
  Axis? acceleration;
  Axis? gyroscope;
  Axis? velocity;

  Rocket(
      {this.rocketID,
      this.altitude,
      this.coordinates,
      this.acceleration,
      this.gyroscope,
      this.velocity});

  Rocket.fromJson(Map<String, dynamic> json) {
    rocketID = json['rocketID'];
    altitude = json['altitude'];
    coordinates = json['coordinates'] != null
        ? new Geopoint.fromJson(json['Geopoint'])
        : null;
    acceleration = json['acceleration'] != null
        ? new Axis.fromJson(json['acceleration'])
        : null;
    gyroscope = json['gyroscope'] != null
        ? new Axis.fromJson(json['gyroscope'])
        : null;
    velocity = json['velocity'] != null
        ? new Axis.fromJson(json['velocity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rocketID'] = this.rocketID;
    data['altitude'] = this.altitude;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.toJson();
    }
    if (this.acceleration != null) {
      data['acceleration'] = this.acceleration!.toJson();
    }
    if (this.gyroscope != null) {
      data['gyroscope'] = this.gyroscope!.toJson();
    }
    if (this.velocity != null) {
      data['velocity'] = this.velocity!.toJson();
    }
    return data;
  }
}

class Geopoint {
  int? latitude;
  int? longitude;

  Geopoint({this.latitude, this.longitude});

  Geopoint.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Axis {
  int? x;
  int? y;
  int? z;

  Axis({this.x, this.y, this.z});

  Axis.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    z = json['z'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['z'] = this.z;
    return data;
  }
}