class Fare {
  late String reference;
  late int baseFare;
  late int minimumFare;
  late int perKmFare;
  late double perMinuteFare;
  late bool isActive;

  Fare(this.reference, this.minimumFare, this.baseFare, this.perKmFare, this.perMinuteFare, this.isActive);

  Map<String, dynamic> get toMap => {
        "baseFare": baseFare,
        "minimumFare": minimumFare,
        "perKmFare": perKmFare,
        "perMinuteFare": perMinuteFare,
        "isActive": isActive,
      };

  Fare.fromMap(String ref, Map<String, dynamic> map) {
    reference = ref;
    baseFare = map["baseFare"] ?? 0;
    minimumFare = map["minimumFare"] ?? 0;
    perKmFare = map["perKmFare"] ?? 0;
    perMinuteFare = double.tryParse(map["perMinuteFare"].toString()) ?? 0;
    isActive = map["isActive"];
  }
}
