class MyTrips {
  late String reference;
  late String passengerReference;
  late String pickupLabel;
  late String destinationLabel;
  late int fare;
  late int? startTime;
  late int? endTime;
  late double distance;

  MyTrips(this.reference, this.passengerReference, this.pickupLabel, this.destinationLabel, this.fare, this.startTime, this.endTime, this.distance);

  MyTrips.fromMap(String ref, Map<String, dynamic> map) {
    reference = ref;
    passengerReference = map["passengerReference"];
    pickupLabel = map["pickup"]["label"];
    destinationLabel = map["destination"]["label"];
    startTime = map["startAt"] ?? 0;
    endTime = map["endAt"] ?? 0;
    distance = map["distance"];
    fare = map["fare"];
  }
}
