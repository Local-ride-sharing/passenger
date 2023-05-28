import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/repository/repository_ride.dart';

part 'ride_rating_state.dart';

class RideRatingCubit extends Cubit<RideRatingState> {
  late RideRepository _repo;

  RideRatingCubit() : super(RideRatingInitial()) {
    _repo = RideRepository();
  }

  void submit(Ride ride) {
    emit(RideRatingNetworking());
    _repo.submitRating(ride).then((response) {
      if (response.success && response.result != null) {
        emit(RideRatingSuccess());
      } else {
        emit(RideRatingError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
