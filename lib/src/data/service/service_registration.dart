import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class RegistrationService {
  cloud_firestore.FirebaseFirestore firestore = cloud_firestore.FirebaseFirestore.instance;

  Future<NetworkResponse<void>> update(Passenger passenger) async {
    try {
      await firestore.collection(DatabaseTable.passenger).doc(passenger.reference).set(passenger.toMap);
      return NetworkResponse(result: null, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<String?>> upload(String reference, String filePath) async {
    try {
      storage.Reference storageReference = storage.FirebaseStorage.instance.ref("${DatabaseTable.passenger}/$reference.jpg");
      storage.UploadTask uploadTask = storageReference.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => null);
      return NetworkResponse(result: await snapshot.ref.getDownloadURL(), success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }
}
