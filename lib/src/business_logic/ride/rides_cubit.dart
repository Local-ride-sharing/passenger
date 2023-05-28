import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/repository/repository_ride.dart';
part 'rides_state.dart';

class RidesCubit extends Cubit<RidesState> {
  late RideRepository _repo;

  RidesCubit() : super(RidesInitial()) {
    _repo = RideRepository();
  }

  void monitor(String reference) {
    emit(RidesNetworking());
    try {
      _repo.monitor(reference).listen((data) {
        parse(data);
      });
    } catch (error) {
      emit(RidesError(error: error.toString()));
    }
  }

  void parse(QuerySnapshot<Map<String, dynamic>> data) {
    final List<Ride> rides = [];
    for (var element in data.docs) {
      rides.add(Ride.fromMap(element.data()));
    }
    emit(RidesSuccess(data: rides));
  }
}
