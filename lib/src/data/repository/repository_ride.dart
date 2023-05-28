import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/service/service_ride.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class RideRepository {
  late RideService _service;

  RideRepository() {
    _service = RideService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> monitor(String reference) => _service.monitor(reference);

  Future<NetworkResponse<Direction?>> findDirection(double pickupLat, double pickupLng, double destinationLat, double destinationLng) async {
    return await _service.findDirection(pickupLat, pickupLng, destinationLat, destinationLng);
  }

  Future<NetworkResponse<Ride?>> createRide(Ride ride) async {
    return await _service.createRide(ride);
  }

  Future<NetworkResponse<bool?>> cancelRide(Ride ride) async {
    return await _service.update(ride);
  }

  Future<NetworkResponse<bool?>> submitRating(Ride ride) async {
    return await _service.update(ride);
  }

  Future<NetworkResponse<List<Driver>?>> findDriver(String vehicleReference) async {
    return await _service.findDrivers(vehicleReference);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> findRide(String reference) {
    return _service.findRide(reference);
  }
}
