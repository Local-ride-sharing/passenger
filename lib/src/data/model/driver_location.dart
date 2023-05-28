class DriverLocation {
  late double latitude;
  late double longitude;
  late double heading;
  late bool status;
  late int lastUpdatedAt;

  DriverLocation(this.latitude, this.longitude, this.heading, this.status, this.lastUpdatedAt);

  Map<String, dynamic> get toMap => {
    "latitude": latitude,
    "longitude": longitude,
    "heading": heading,
    "status": status,
    "lastUpdatedAt":lastUpdatedAt,
  };

  DriverLocation.fromMap(Map<String, dynamic> map) {
    latitude = map["latitude"];
    longitude = map["longitude"];
    heading = map["heading"];
    status = map["status"];
    lastUpdatedAt = map["lastUpdatedAt"];
  }
}
