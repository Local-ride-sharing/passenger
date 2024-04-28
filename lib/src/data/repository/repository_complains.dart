import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/src/data/service/service_complains.dart';

class ComplainsRepository {
  late ComplainsService _service;

  ComplainsRepository() {
    _service = ComplainsService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorComplains => _service.monitorComplains;
}
