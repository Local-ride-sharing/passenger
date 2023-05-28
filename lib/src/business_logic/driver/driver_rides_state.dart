part of 'driver_rides_cubit.dart';

@immutable
abstract class DriverRidesState {}

class DriverRidesInitial extends DriverRidesState {}

class DriverRidesError extends DriverRidesState {
  final String error;

  DriverRidesError({required this.error});
}

class DriverRidesNetworking extends DriverRidesState {}

class DriverRidesSuccess extends DriverRidesState {
  final List<Ride> data;

  DriverRidesSuccess({required this.data});
}
