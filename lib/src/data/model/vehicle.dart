class Vehicle {
  late String reference;
  late String enName;
  late String bnName;
  late int searchRadius;
  late int baseFare;
  late int minimumFare;
  late int perKmFare;
  late double perMinuteFare;
  late int numberOfSeat;
  late String image;
  late bool hasInstantRide;
  late bool hasPoints;
  late bool hasReservation;
  late bool isActive;

  Vehicle({
    required this.reference,
    required this.enName,
    required this.bnName,
    required this.searchRadius,
    required this.baseFare,
    required this.minimumFare,
    required this.perKmFare,
    required this.perMinuteFare,
    required this.numberOfSeat,
    required this.image,
    required this.hasInstantRide,
    required this.hasPoints,
    required this.hasReservation,
    required this.isActive,
  });

  Map<String, dynamic> get toMap => {
        'reference': this.reference,
        'enName': this.enName,
        'bnName': this.bnName,
        'searchRadius': this.searchRadius,
        'baseFare': this.baseFare,
        'minimumFare': this.minimumFare,
        'perKmFare': this.perKmFare,
        'perMinuteFare': this.perMinuteFare,
        'numberOfSeat': this.numberOfSeat,
        'image': this.image,
        'hasInstantRide': this.hasInstantRide,
        'hasPoints': this.hasPoints,
        'hasReservation': this.hasReservation,
        'isActive': this.isActive,
      };

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      reference: map['reference'] as String,
      enName: map['enName'] as String,
      bnName: map['bnName'] as String,
      searchRadius: map['searchRadius'] as int,
      baseFare: map['baseFare'] as int,
      minimumFare: map['minimumFare'] as int,
      perKmFare: map['perKmFare'] as int,
      perMinuteFare: double.tryParse(map['perMinuteFare'].toString()) ?? 0.0,
      numberOfSeat: map['numberOfSeat'] as int,
      image: map['image'] as String,
      hasInstantRide: map['hasInstantRide'] as bool,
      hasPoints: map['hasPoints'] as bool,
      hasReservation: map['hasReservation'] as bool,
      isActive: map['isActive'] as bool,
    );
  }
}
