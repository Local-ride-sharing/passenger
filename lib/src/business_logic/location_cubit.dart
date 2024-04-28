import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:passenger/src/data/model/current_location.dart';

class LocationCubit extends Cubit<CurrentLocation> {
  LocationCubit() : super(CurrentLocation(latitude: 23.012965, longitude: 91.4002359, heading: 0));

  track() async {
    Location.instance.onLocationChanged.listen((position) async {
      emit(CurrentLocation(
          latitude: position.latitude ?? 23.012965, longitude: position.longitude ?? 91.4002359, heading: state.heading));
    });

    if (state.latitude == 0 || state.longitude == 0) {
      final LocationData data = await Location.instance.getLocation();
      emit(CurrentLocation(
          latitude: data.latitude ?? state.latitude, longitude: data.longitude ?? state.longitude, heading: state.heading));
    }
  }
}
