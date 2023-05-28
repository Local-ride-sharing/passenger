import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class VehicleService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorInstantRideVehicles => firestore
      .collection(DatabaseTable.vehicle)
      .where("isActive", isEqualTo: true)
      .where("hasInstantRide", isEqualTo: true)
      .orderBy("enName")
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorPointVehicles => firestore
      .collection(DatabaseTable.vehicle)
      .where("isActive", isEqualTo: true)
      .where("hasPoints", isEqualTo: true)
      .orderBy("enName")
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorReservationVehicles => firestore
      .collection(DatabaseTable.vehicle)
      .where("isActive", isEqualTo: true)
      .where("hasReservation", isEqualTo: true)
      .orderBy("enName")
      .snapshots();

  Future<NetworkResponse<Vehicle?>> findVehicleByReference(String reference) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection(DatabaseTable.vehicle).doc(reference).get();
      final Vehicle? vehicle = Vehicle.fromMap(snapshot.data() ?? {});
      return NetworkResponse(result: vehicle, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }
}
