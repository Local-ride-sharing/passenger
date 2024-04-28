import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/src/utils/database_tables.dart';

class ComplainsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorComplains =>
      firestore.collection(DatabaseTable.complains).where("isActive", isEqualTo: true).snapshots();
}
