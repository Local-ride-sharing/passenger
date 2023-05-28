import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/repository/repository_ride.dart';

part 'direction_state.dart';

class DirectionCubit extends Cubit<DirectionState> {
  late RideRepository _repo;

  DirectionCubit() : super(DirectionInitial()) {
    _repo = RideRepository();
  }

  void findDirection(double pickupLat, double pickupLng, double destinationLat, double destinationLng) {
    emit(DirectionNetworking());
    _repo.findDirection(pickupLat, pickupLng, destinationLat, destinationLng).then((response) {
      if (response.success && response.result != null) {
        emit(DirectionSuccess(data: response.result!));
      } else {
        emit(DirectionError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
