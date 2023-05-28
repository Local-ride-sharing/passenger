import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/repository/repository_driver.dart';

part 'driver_rides_state.dart';

class DriverRidesCubit extends Cubit<DriverRidesState> {
  late DriverRepository _repo;

  DriverRidesCubit() : super(DriverRidesInitial()) {
    _repo = DriverRepository();
  }

  void findDriverRides(String reference) {
    emit(DriverRidesNetworking());
    _repo.findRides(reference).listen((data) {
      parse(data);
    });
  }

  void parse(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Ride> results = data.docs.map((item) {
        final String reference = item.id;
        final Map<String, dynamic> map = item.data();
        map.addAll({"reference": reference});
        return Ride.fromMap(map);
      }).toList();
      emit(DriverRidesSuccess(data: results));
    } catch (error) {
      emit(DriverRidesError(error: error.toString()));
    }
  }
}
