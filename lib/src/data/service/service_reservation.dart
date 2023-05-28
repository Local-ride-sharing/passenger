import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class ReservationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> monitor(String reference) =>
      firestore.collection(DatabaseTable.reservations).where("passengerReference", isEqualTo: reference).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorBidding(String reference) => firestore.collection(DatabaseTable.reservations).doc(reference).snapshots();

  Future<NetworkResponse<Null>> create(Reservation reservation) async {
    try {
      await firestore.collection(DatabaseTable.reservations).add(reservation.toMap);
      return NetworkResponse(result: null, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<Null>> update(Reservation reservation) async {
    try {
      await firestore.collection(DatabaseTable.reservations).doc(reservation.reference).set(reservation.toMap);
      return NetworkResponse(result: null, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<Null>> delete(String reference) async {
    try {
      await firestore.collection(DatabaseTable.reservations).doc(reference).delete();
      return NetworkResponse(result: null, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }
}
