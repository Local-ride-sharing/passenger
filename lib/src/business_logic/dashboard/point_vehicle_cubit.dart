import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/data/repository/repository_vehicle.dart';

part 'point_vehicle_state.dart';

class PointVehicleCubit extends Cubit<PointVehicleState> {
  late VehicleRepository _repo;

  PointVehicleCubit() : super(PointVehicleInitial()) {
    _repo = VehicleRepository();
  }

  void monitorVehicles() {
    emit(PointVehicleNetworking());
    _repo.monitorPointVehicles.listen((data) {
      parseVehicles(data);
    });
  }

  void parseVehicles(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Vehicle> results = data.docs.map((item) => Vehicle.fromMap(item.data())).toList();
      emit(PointVehicleSuccess(data: results));
    } catch (error) {
      emit(PointVehicleError(error: "Something went wrong"));
    }
  }
}
