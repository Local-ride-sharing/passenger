import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/service/service_point.dart';

class PointRepository {
  late PointService _service;

  PointRepository() {
    _service = PointService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorPoints => _service.monitorPoints;
}
