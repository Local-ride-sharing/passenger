import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';

class ProfileService {
  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorProfile(String reference) {
    return FirebaseFirestore.instance.collection(DatabaseTable.passenger).doc(reference).snapshots();
  }
}
