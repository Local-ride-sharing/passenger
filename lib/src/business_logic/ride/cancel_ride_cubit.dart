import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/repository/repository_ride.dart';

part 'cancel_ride_state.dart';

class CancelRideCubit extends Cubit<CancelRideState> {
  late RideRepository _repo;

  CancelRideCubit() : super(CancelRideInitial()) {
    _repo = RideRepository();
  }

  void cancelRide(Ride ride) {
    emit(CancelRideNetworking());
    _repo.cancelRide(ride).then((response) {
      if (response.success && response.result != null) {
        emit(CancelRideSuccess());
      } else {
        emit(CancelRideError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
