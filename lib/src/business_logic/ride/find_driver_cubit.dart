import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/repository/repository_ride.dart';
import 'package:tmoto_passenger/src/utils/constants.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';

part 'find_driver_state.dart';

class FindDriverCubit extends Cubit<FindDriverState> {
  late RideRepository _repo;

  FindDriverCubit() : super(FindDriverInitial()) {
    _repo = RideRepository();
  }

  void findDrivers(Ride ride, Vehicle vehicle) {
    emit(FindDriverNetworking());
    _repo.findDriver(ride.vehicleReference).then((response) {
      if (response.success) {
        if (response.result != null) {
          List<Driver> result = [];
          final List<Driver> femaleResult = [];
          final List<Driver> maleResult = [];
          response.result!.forEach((driver) {
            if ((driver.location.latitude >
                    minLatitude(ride.pickup.latitude, vehicle.searchRadius)) &&
                (driver.location.latitude <
                    maxLatitude(ride.pickup.latitude, vehicle.searchRadius)) &&
                (driver.location.longitude >
                    minLongitude(ride.pickup.longitude, vehicle.searchRadius)) &&
                (driver.location.longitude <
                    maxLatitude(ride.pickup.longitude, vehicle.searchRadius)) &&
                (DateTime.now()
                        .difference(
                            DateTime.fromMillisecondsSinceEpoch(driver.location.lastUpdatedAt))
                        .inDays ==
                    0)) {
              if (driver.gender == Gender.female) {
                femaleResult.add(driver);
              } else if (driver.gender == Gender.male) {
                maleResult.add(driver);
              }
            }
          });
          maleResult.sort((a, b) => Geolocator.distanceBetween(ride.pickup.latitude,
                  ride.pickup.longitude, a.location.latitude, a.location.longitude)
              .compareTo(Geolocator.distanceBetween(ride.pickup.latitude,
                  ride.pickup.longitude, b.location.latitude, b.location.longitude)));
          femaleResult.sort(
            (a, b) => Geolocator.distanceBetween(ride.pickup.latitude, ride.pickup.longitude,
                    a.location.latitude, a.location.longitude)
                .compareTo(
              Geolocator.distanceBetween(ride.pickup.latitude, ride.pickup.longitude,
                  b.location.latitude, b.location.longitude),
            ),
          );
          if (ride.priority == RidePriority.female) {
            result = femaleResult;
          } else if (ride.priority == RidePriority.male) {
            result = maleResult;
          } else if (ride.priority == RidePriority.femalePriority) {
            result.addAll(femaleResult);
            result.addAll(maleResult);
          }

          emit(FindDriverSuccess(data: result));
        } else {
          emit(FindDriverError(error: response.error ?? "something went wrong"));
        }
      } else {
        emit(FindDriverError(error: response.error ?? "failed to retrieve nearby drivers"));
      }
    });
  }
}
