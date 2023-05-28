import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/constants.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class RideService {
  Stream<QuerySnapshot<Map<String, dynamic>>> monitor(String reference) =>
      FirebaseFirestore.instance
          .collection(DatabaseTable.rides)
          .where("passengerReference", isEqualTo: reference)
          .where("isCanceled", isNull: true)
          .snapshots();

  Future<NetworkResponse<Direction?>> findDirection(
      double pickupLat, double pickupLng, double destinationLat, double destinationLng) async {
    try {
      Response response = await get(Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=$pickupLat,$pickupLng&destination=$destinationLat,"
        "$destinationLng&mode=driving&departure_time=now&key=$MAP_API_WEB_KEY&dir_action=navigate",
      ));

      if (response.statusCode == 200) {
        final Direction direction = Direction.fromJson(json.decode(response.body));
        return NetworkResponse(result: direction, success: true);
      } else {
        return NetworkResponse(result: null, success: false, error: "Failed to retrieve direction");
      }
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<Ride?>> createRide(Ride ride) async {
    try {
      ride.createdAt = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance
          .collection(DatabaseTable.rides)
          .doc(ride.reference)
          .set(ride.toMap);
      return NetworkResponse(result: ride, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<bool?>> update(Ride ride) async {
    try {
      await FirebaseFirestore.instance
          .collection(DatabaseTable.rides)
          .doc(ride.reference)
          .set(ride.toMap);
      return NetworkResponse(result: true, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Future<NetworkResponse<List<Driver>?>> findDrivers(String vehicleReference) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(DatabaseTable.drivers)
          .where("location.status", isEqualTo: true)
          .where("vehicle.vehicleType", isEqualTo: vehicleReference)
          .get();

      List<Driver> list = [];

      result.docs.forEach((element) {
        Map<String, dynamic> snapshot = element.data() as Map<String, dynamic>;
        list.add(Driver.fromMap(element.id, snapshot));
      });

      return NetworkResponse(result: list, success: true);
    } catch (error) {
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> findRide(String reference) =>
      FirebaseFirestore.instance.collection(DatabaseTable.rides).doc(reference).snapshots();
}
