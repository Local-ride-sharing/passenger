import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/src/utils/database_tables.dart';

class PointService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorPoints =>
      firestore.collection(DatabaseTable.points).where("isActive", isEqualTo: true).snapshots();
}
