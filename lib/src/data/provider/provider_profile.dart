import 'package:flutter/material.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';

class ProfileProvider extends ChangeNotifier {
  Passenger? profile;

  saveProfile(Passenger data) {
    profile = data;
    notifyListeners();
  }
}
