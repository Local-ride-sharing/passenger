import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:passenger/src/data/model/driver.dart';

class DriverProvider extends ChangeNotifier {
  final Map<String, Driver> passengers = HashMap<String, Driver>();

  Driver? get(String reference) => passengers[reference];

  bool exists(String reference) => passengers.containsKey(reference);

  void add(Driver passenger) {
    passengers[passenger.reference] = passenger;
    notifyListeners();
  }
}
