import 'package:flutter/material.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';

class InheritedRide extends InheritedWidget {
  final Ride ride;

  InheritedRide({required this.ride, required Widget child}) : super(child: child);

  static InheritedRide of(BuildContext context) {
    final InheritedRide? result = context.dependOnInheritedWidgetOfExactType<InheritedRide>();
    assert(result != null, 'No InheritedRide found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedRide old) {
    return true;
  }
}
