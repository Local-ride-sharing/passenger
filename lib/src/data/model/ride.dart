import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/utils/enums.dart';

class Ride {
  late String reference;
  late String passengerReference;
  String? driverReference;
  late Address pickup;
  late Address destination;
  Address? dropOff;
  late String vehicleReference;
  late double distance;
  late int duration;
  late int fare;
  String? rejectionReason;
  late String polyline;
  int? rating;
  String? comments;
  List<String>? complains;
  int? startAt;
  int? endAt;
  bool? isCanceled;
  late RidePriority priority;
  late RideType rideType;
  double? commission;
  late int createdAt;
  late RideCurrentStatus rideCurrentStatus;

  Ride({
    required this.reference,
    required this.passengerReference,
    required this.pickup,
    required this.destination,
    this.dropOff,
    required this.vehicleReference,
    required this.distance,
    required this.fare,
    required this.polyline,
    this.driverReference,
    this.rejectionReason,
    this.rating,
    this.complains,
    this.startAt,
    this.endAt,
    this.isCanceled,
    required this.priority,
    this.comments,
    required this.duration,
    required this.rideType,
    this.createdAt = 0,
    this.commission,
    required this.rideCurrentStatus,
  });

  Ride.fromMap(Map<String, dynamic> map) {
    reference = map["reference"] ?? "";
    pickup = Address.fromMap(map["pickup"] ?? {});
    destination = Address.fromMap(map["destination"] ?? {});
    dropOff = Address.fromMap(map["dropOff"] ?? {});
    vehicleReference = map["vehicleReference"] ?? "";
    passengerReference = map["passengerReference"] ?? "";
    distance = map["distance"] ?? 0;
    fare = map["fare"] ?? 0;
    polyline = map["polyline"] ?? "";
    driverReference = map["driverReference"] ?? "";
    rejectionReason = map["rejectionReason"];
    rating = map["rating"];
    comments = map["comments"];
    startAt = map["startAt"];
    endAt = map["endAt"];
    duration = map["duration"] ?? 0;
    commission = map["commission"] ?? 0;
    complains = List<String>.from(map["complains"] ?? []);
    isCanceled = map["isCanceled"] ?? false;
    priority = RidePriority.values.elementAt(map["priority"] ?? 2);
    rideType = RideType.values.elementAt(map["rideType"] ?? 0);
    createdAt = map["createdAt"] ?? 0;
    rideCurrentStatus = RideCurrentStatus.values.elementAt(map["rideCurrentStatus"] ?? 5);
  }

  Map<String, dynamic> get toMap => {
        "reference": reference,
        "pickup": pickup.toMap,
        "destination": destination.toMap,
        "dropOff": dropOff?.toMap,
        "passengerReference": passengerReference,
        "vehicleReference": vehicleReference,
        "distance": distance,
        "fare": fare,
        "polyline": polyline,
        "driverReference": driverReference,
        "rejectionReason": rejectionReason,
        "rating": rating,
        "comments": comments,
        "duration": duration,
        "commission": commission,
        "startAt": startAt,
        "endAt": endAt,
        "complains": complains,
        "isCanceled": isCanceled,
        "createdAt": createdAt,
        "priority": RidePriority.values.indexOf(priority),
        "rideCurrentStatus": RideCurrentStatus.values.indexOf(rideCurrentStatus),
        "rideType": RideType.values.indexOf(rideType),
      };
}
