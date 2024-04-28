import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:passenger/src/data/model/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  Map<String, Vehicle> items = HashMap<String, Vehicle>();

  void add(Vehicle vehicle) {
    if (!doesExists(vehicle.reference)) {
      items[vehicle.reference] = vehicle;
      notifyListeners();
    }
  }

  void addAll(List<Vehicle> vehicles) {
    vehicles.forEach((element) {
      add(element);
    });
  }

  bool doesExists(String reference) {
    return items.containsKey(reference);
  }

  Vehicle? get(String reference) {
    return items[reference];
  }
}
