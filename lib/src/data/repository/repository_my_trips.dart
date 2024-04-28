import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/src/data/model/my_trips.dart';
import 'package:passenger/src/data/service/service_my_trips.dart';

class MyTripsRepository {
  late MyTripsService _service;
  Map<String, MyTrips> results = HashMap<String, MyTrips>();

  MyTripsRepository() {
    _service = MyTripsService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> monitorMyTrips(String reference) => _service.monitorTrips(reference);

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorMyCancelledTrips => _service.monitorMyCancelledTrips;
}
