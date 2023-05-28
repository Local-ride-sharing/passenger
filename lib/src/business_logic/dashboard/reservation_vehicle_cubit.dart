import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/repository/repository_vehicle.dart';

part 'reservation_vehicle_state.dart';

class ReservationVehicleCubit extends Cubit<ReservationVehicleState> {
  late VehicleRepository _repo;

  ReservationVehicleCubit() : super(ReservationVehicleInitial()) {
    _repo = VehicleRepository();
  }

  void monitorVehicles() {
    emit(ReservationVehicleNetworking());
    _repo.monitorReservationVehicles.listen((data) {
      parseVehicles(data);
    });
  }

  void parseVehicles(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Vehicle> results = data.docs.map((item) => Vehicle.fromMap(item.data())).toList();
      emit(ReservationVehicleSuccess(data: results));
    } catch (error) {
      emit(ReservationVehicleError(error: "Something went wrong"));
    }
  }
}
