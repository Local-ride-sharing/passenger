import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tmoto_passenger/src/data/model/fare.dart';

class FareProvider extends ChangeNotifier {
  Map<String, Fare> fares = HashMap<String, Fare>();

  void save(List<Fare> list) {
    list.forEach((element) {
      if(!fares.containsKey(element.reference)) {
        fares[element.reference] = element;
      }
    });
    notifyListeners();
  }

  Fare? findFare(String reference) => fares[reference];
}