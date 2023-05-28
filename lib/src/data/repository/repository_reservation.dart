import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/data/service/service_reservation.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class ReservationRepository {
  late ReservationService _service;

  ReservationRepository() {
    _service = ReservationService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> monitor(String reference) => _service.monitor(reference);
  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorBidding(String reference) => _service.monitorBidding(reference);

  Future<NetworkResponse<Null>> create(Reservation reservation) async {
    return _service.create(reservation);
  }

  Future<NetworkResponse<Null>> update(Reservation reservation) async {
    return _service.update(reservation);
  }

  Future<NetworkResponse<Null>> delete(String reference) async {
    return _service.delete(reference);
  }
}
