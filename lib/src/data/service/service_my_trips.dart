import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:tmoto_passenger/src/utils/database_tables.dart';

class MyTripsService {
  cloud_firestore.FirebaseFirestore firestore = cloud_firestore.FirebaseFirestore.instance;

  Stream<cloud_firestore.QuerySnapshot<Map<String, dynamic>>> monitorTrips(String reference) =>
      firestore.collection(DatabaseTable.rides).where("passengerReference", isEqualTo: reference).snapshots();

  Stream<cloud_firestore.QuerySnapshot<Map<String, dynamic>>> get monitorMyCancelledTrips =>
      firestore.collection(DatabaseTable.rides).where("isCanceled", isNull: true).snapshots();
}
