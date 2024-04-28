import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/repository/repository_ride.dart';

part 'single_ride_state.dart';

class SingleRideCubit extends Cubit<SingleRideState> {
  late RideRepository _repo;

  SingleRideCubit() : super(SingleRideInitial()) {
    _repo = RideRepository();
  }

  void findRide(String reference) {
    emit(SingleRideNetworking());
    try {
      _repo.findRide(reference).listen((data) {
        parse(data);
      });
    } catch (error) {
      emit(SingleRideError(error: error.toString()));
    }
  }

  void parse(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final String reference = snapshot.id;
      final Map<String, dynamic> map = snapshot.data() ?? {};
      map.addAll({"reference": reference});
      final Ride ride = Ride.fromMap(map);
      emit(SingleRideSuccess(data: ride));
    } catch (error) {
      emit(SingleRideError(error: error.toString()));
    }
  }
}
