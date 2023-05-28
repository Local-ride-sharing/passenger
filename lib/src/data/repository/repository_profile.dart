import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/service/service_profile.dart';

class ProfileRepository {
  late ProfileService _service;

  ProfileRepository() {
    _service = ProfileService();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorProfile(String reference) {
    return _service.monitorProfile(reference);
  }
}
