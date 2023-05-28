import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/fare.dart';
import 'package:tmoto_passenger/src/data/service/service_fare.dart';

class FareRepository {
  late FareService _service;
  Map<String, Fare> results = HashMap<String, Fare>();

  FareRepository() {
    _service = FareService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorFares =>
      _service.monitorFares;
}
