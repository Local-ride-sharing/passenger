class Bid {
  late String driverReference;
  late int amount;
  late int date;

  Bid({
    required this.driverReference,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> get toMap {
    return {
      'driverReference': this.driverReference,
      'amount': this.amount,
      'date': this.date,
    };
  }

  factory Bid.fromMap(Map<String, dynamic> map) {
    return Bid(
      driverReference: map['driverReference'] as String,
      amount: map['amount'] as int,
      date: map['date'] as int,
    );
  }
}
