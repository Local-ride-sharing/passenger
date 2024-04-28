import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/repository/repository_ride.dart';

part 'create_ride_state.dart';

class CreateRideCubit extends Cubit<CreateRideState> {
  late RideRepository _repo;

  CreateRideCubit() : super(CreateRideInitial()) {
    _repo = RideRepository();
  }

  void createRide(Ride ride) {
    emit(CreateRideNetworking());
    _repo.createRide(ride).then((response) {
      if (response.success) {
        if (response.result != null) {
          emit(CreateRideSuccess(data: response.result!));
        } else {
          emit(CreateRideError(error: response.error ?? "something went wrong"));
        }
      } else {
        emit(CreateRideError(error: response.error ?? "failed to create ride"));
      }
    });
  }
}
