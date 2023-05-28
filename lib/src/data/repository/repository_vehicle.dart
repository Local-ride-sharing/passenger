import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/service/service_vehicle.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class VehicleRepository {
  late VehicleService _service;

  VehicleRepository() {
    _service = VehicleService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorInstantRideVehicles =>
      _service.monitorInstantRideVehicles;

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorPointVehicles =>
      _service.monitorPointVehicles;

  Stream<QuerySnapshot<Map<String, dynamic>>> get monitorReservationVehicles =>
      _service.monitorReservationVehicles;

  Future<NetworkResponse<Vehicle?>> findVehicle(String reference) async {
    return await _service.findVehicleByReference(reference);
  }
}
