import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/utils/database_tables.dart';

class SavedAddressService {
  cloud_firestore.FirebaseFirestore firestore = cloud_firestore.FirebaseFirestore.instance;

  Stream<cloud_firestore.QuerySnapshot<Map<String, dynamic>>> monitorSavedAddress(String reference) =>
      firestore.collection(DatabaseTable.savedAddress).where("passengerReference", isEqualTo: reference).snapshots();

  Future<String?> createSavedAddress(SavedAddress savedAddress) async {
    try {
      final cloud_firestore.DocumentReference reference =
          await firestore.collection(DatabaseTable.savedAddress).add(savedAddress.toMap);
      return reference.path;
    } catch (error) {
      return null;
    }
  }

  Future<String?> updateSavedAddress(SavedAddress savedAddress) async {
    try {
      await firestore.collection(DatabaseTable.savedAddress).doc(savedAddress.reference).update(savedAddress.toMap);
      return savedAddress.reference;
    } catch (error) {
      return null;
    }
  }

  Future<String?> deleteAddress(String addressRef) async {
    try {
      await firestore.collection(DatabaseTable.savedAddress).doc(addressRef).delete();
      return addressRef;
    } catch (error) {
      return null;
    }
  }
}
