import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:passenger/src/utils/database_tables.dart';

class FareService {
  cloud_firestore.FirebaseFirestore firestore = cloud_firestore.FirebaseFirestore.instance;

  Stream<cloud_firestore.QuerySnapshot<Map<String, dynamic>>> get monitorFares =>
      firestore.collection(DatabaseTable.fares).where("isActive", isEqualTo: true).snapshots();
}
