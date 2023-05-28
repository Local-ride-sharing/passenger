import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/repository/repository_vehicle.dart';

part 'single_vehicle_state.dart';

class SingleVehicleCubit extends Cubit<SingleVehicleState> {
  late VehicleRepository _repo;

  SingleVehicleCubit() : super(SingleVehicleInitial()) {
    _repo = VehicleRepository();
  }

  void findVehicle(String reference) {
    emit(SingleVehicleNetworking());
    _repo.findVehicle(reference).then((response) {
      if (response.success) {
        if (response.result != null) {
          emit(SingleVehicleSuccess(data: response.result!));
        } else {
          emit(SingleVehicleError(error: "Vehicle not found"));
        }
      } else {
        emit(SingleVehicleError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
