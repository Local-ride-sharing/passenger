import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/data/model/bid.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';

class Reservation {
  late String reference;
  late String passengerReference;
  late String vehicleReference;
  late Address pickup;
  late Address destination;
  late bool isRoundTrip;
  late int departureTime;
  late int? returnTime;
  late int biddingDeadline;
  late Direction direction;
  late ReservationStatus status;
  late List<Bid> bids;
  late List<Bid> blackListed;
  Bid? primarySelection;
  Bid? selected;
  bool closed = false;
  double? commission;

  Reservation({
    required this.reference,
    required this.passengerReference,
    required this.vehicleReference,
    required this.pickup,
    required this.destination,
    required this.isRoundTrip,
    required this.departureTime,
    this.returnTime,
    required this.biddingDeadline,
    required this.direction,
    required this.status,
    required this.bids,
    required this.blackListed,
    this.primarySelection,
    this.selected,
    required this.commission,
    closed,
  });

  Map<String, dynamic> get toMap {
    return {
      'passengerReference': this.passengerReference,
      'vehicleReference': this.vehicleReference,
      'pickup': this.pickup.toMap,
      'destination': this.destination.toMap,
      'isRoundTrip': this.isRoundTrip,
      'departureTime': this.departureTime,
      'returnTime': this.returnTime,
      'biddingDeadline': this.biddingDeadline,
      'commission': this.commission,
      'direction': this.direction.toMap(),
      'status': ReservationStatus.values.indexOf(this.status),
      'bids': this.bids.map((e) => e.toMap).toList(),
      'blackListed': this.blackListed.map((e) => e.toMap).toList(),
      'primarySelection': this.primarySelection?.toMap,
      'selected': this.selected?.toMap,
      'closed': this.closed,
    };
  }

  factory Reservation.fromMap(String ref, Map<String, dynamic> map) {
    return Reservation(
      reference: ref,
      passengerReference: map['passengerReference'] as String,
      vehicleReference: map['vehicleReference'] as String,
      pickup: Address.fromMap(map['pickup']),
      destination: Address.fromMap(map['destination']),
      isRoundTrip: map['isRoundTrip'] as bool,
      departureTime: map['departureTime'] as int,
      returnTime: map['returnTime'],
      biddingDeadline: map['biddingDeadline'] as int,
      direction: Direction.fromMap(map['direction']),
      status: ReservationStatus.values.elementAt(map['status']),
      bids: map['bids'] == null
          ? []
          : List<Map<String, dynamic>>.from(map['bids']).map((e) => Bid.fromMap(e)).toList(),
      blackListed: map['blackListed'] == null
          ? []
          : List<Map<String, dynamic>>.from(map['blackListed']).map((e) => Bid.fromMap(e)).toList(),
      primarySelection:
          map['primarySelection'] == null ? null : Bid.fromMap(map['primarySelection']),
      selected: map['selected'] == null ? null : Bid.fromMap(map['selected']),
      closed: map['closed'],
      commission: map["commission"] ?? 0,
    );
  }

  bool isSelectedPrimarily(String reference) {
    return primarySelection?.driverReference == reference;
  }
}
