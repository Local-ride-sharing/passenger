class Direction {
  late String polyline;
  late int duration;
  late double distance;

  Direction({
    required this.polyline,
    required this.duration,
    required this.distance,
  });

  Direction.fromJson(Map<String, dynamic> json) {
    polyline = json["routes"][0]["overview_polyline"]["points"];
    duration = json["routes"][0]["legs"][0]["duration"]["value"] ~/ 60;
    distance = json["routes"][0]["legs"][0]["distance"]["value"] / 1000;
  }

  Map<String, dynamic> toMap() {
    return {
      'polyline': this.polyline,
      'duration': this.duration,
      'distance': this.distance,
    };
  }

  factory Direction.fromMap(Map<String, dynamic> map) {
    return Direction(
      polyline: map['polyline'] as String,
      duration: map['duration'] as int,
      distance: map['distance'] as double,
    );
  }
}
