import 'package:tmoto_passenger/src/data/model/address.dart';

class Point {
  late String reference;
  late String vehicleReference;
  late Address enPickup;
  late Address bnPickup;
  late Address enDestination;
  late Address bnDestination;
  late String polyline;
  late double distance;
  late int duration;
  late int baseFare;
  late bool isActive;

  Point({
    required this.reference,
    required this.vehicleReference,
    required this.enPickup,
    required this.bnPickup,
    required this.enDestination,
    required this.bnDestination,
    required this.polyline,
    required this.distance,
    required this.duration,
    required this.baseFare,
    required this.isActive,
  });

  Map<String, dynamic> get toMap => {
        "vehicleReference": vehicleReference,
        "enPickup": enPickup.toMap,
        "bnPickup": bnPickup.toMap,
        "enDestination": enDestination.toMap,
        "bnDestination": bnDestination.toMap,
        "polyline": polyline,
        "distance": distance,
        "duration": duration,
        "baseFare": baseFare,
        "isActive": isActive,
      };

  Point.fromMap(String ref, Map<String, dynamic> map) {
    reference = ref;
    vehicleReference = map["vehicleReference"];
    enPickup = Address.fromMap(map["enPickup"]);
    bnPickup = Address.fromMap(map["bnPickup"]);
    enDestination = Address.fromMap(map["enDestination"]);
    bnDestination = Address.fromMap(map["bnDestination"]);
    polyline = map["polyline"] ?? "";
    distance = map["distance"] ?? 0.0;
    duration = map["duration"] ?? 0;
    baseFare = map["baseFare"] ?? 0;
    isActive = map["isActive"] ?? false;
  }
}
