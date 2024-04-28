import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/repository/repository_my_trips.dart';

part 'my_trips_list_state.dart';

class MyTripsCubit extends Cubit<MyTripsState> {
  late MyTripsRepository _repo;

  MyTripsCubit() : super(MyTripsInitial()) {
    _repo = MyTripsRepository();
  }

  void monitor(String reference) {
    emit(MyTripsNetworking());
    _repo.monitorMyTrips(reference).listen((data) {
      parseMyTrips(data);
    });
  }

  void parseMyTrips(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Ride> rides = [];
      data.docs.forEach((element) {
        final String reference = element.id;
        final Map<String, dynamic> map = element.data();
        map.addAll({"reference": reference});

        rides.add(Ride.fromMap(map));
      });
      rides.sort((b, a) => (a.startAt ?? -1).compareTo(b.startAt ?? -1));
      List<Ride> completed = [];
      List<Ride> canceled = [];
      completed = rides
          .where((element) => element.startAt != null && element.endAt != null && element.driverReference != null)
          .toList();
      canceled = rides.where((element) => element.isCanceled == null || element.isCanceled == true).toList();
      emit(MyTripsSuccess(completed: completed, canceled: canceled));
    } catch (error) {
      emit(MyTripsError(error: error.toString()));
    }
  }
}
