import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/utils/database_tables.dart';
import 'package:passenger/src/utils/network_response.dart';

class DriverService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorSingleDriver(String reference) =>
      firestore.collection(DatabaseTable.drivers).doc(reference).snapshots();

  Future<NetworkResponse<Driver?>> findDriver(String reference) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection(DatabaseTable.drivers).doc(reference).get();
      final Driver? driver = Driver.fromMap(reference, snapshot.data() ?? {});
      return NetworkResponse(result: driver, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> findRides(String reference) =>
      FirebaseFirestore.instance.collection(DatabaseTable.rides).where("driverReference", isEqualTo: reference).snapshots();
}
