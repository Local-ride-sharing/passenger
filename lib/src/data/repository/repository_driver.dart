import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/provider/provider_driver.dart';
import 'package:passenger/src/data/service/service_driver.dart';
import 'package:passenger/src/utils/network_response.dart';

class DriverRepository {
  late DriverService _service;

  DriverRepository() {
    _service = DriverService();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> monitorSingleDriver(String reference) =>
      _service.monitorSingleDriver(reference);

  Future<NetworkResponse<Driver?>> findDriver(BuildContext context, String reference) async {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    if (driverProvider.exists(reference)) {
      return NetworkResponse(result: driverProvider.get(reference), success: true);
    } else {
      NetworkResponse<Driver?> response = await _service.findDriver(reference);
      if (response.success) {
        driverProvider.add(response.result!);
      }
      return response;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> findRides(String reference) => _service.findRides(reference);
}
