import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/repository/repository_vehicle.dart';

part 'instant_ride_state.dart';

class InstantRideVehicleCubit extends Cubit<InstantRideVehicleState> {
  late VehicleRepository _repo;

  InstantRideVehicleCubit() : super(InstantRideVehicleInitial()) {
    _repo = VehicleRepository();
  }

  void monitorVehicles() {
    emit(InstantRideVehicleNetworking());
    _repo.monitorInstantRideVehicles.listen((data) {
      parseVehicles(data);
    });
  }

  void parseVehicles(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Vehicle> results = data.docs.map((item) => Vehicle.fromMap(item.data())).toList();
      emit(InstantRideVehicleSuccess(data: results));
    } catch (error) {
      emit(InstantRideVehicleError(error: "Something went wrong"));
    }
  }
}
