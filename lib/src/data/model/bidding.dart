class Bidding {
  late String reference;
  late String reservationReference;
  late String driverReference;
  late int amount;
  late int date;

  Bidding({
    required this.reference,
    required this.reservationReference,
    required this.driverReference,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> get toMap {
    return {
      'reservationReference': this.reservationReference,
      'driver': this.driverReference,
      'amount': this.amount,
      'date': this.date,
    };
  }

  factory Bidding.fromMap(String ref, Map<String, dynamic> map) {
    return Bidding(
      reference: ref,
      reservationReference: map['reservationReference'] as String,
      driverReference: map['driverReference'] as String,
      amount: map['amount'] as int,
      date: map['date'] as int,
    );
  }
}
