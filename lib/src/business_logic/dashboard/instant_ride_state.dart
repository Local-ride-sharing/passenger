part of 'instant_ride_cubit.dart';

@immutable
abstract class InstantRideVehicleState {}

class InstantRideVehicleInitial extends InstantRideVehicleState {}

class InstantRideVehicleError extends InstantRideVehicleState {
  final String error;

  InstantRideVehicleError({required this.error});
}

class InstantRideVehicleNetworking extends InstantRideVehicleState {}

class InstantRideVehicleSuccess extends InstantRideVehicleState {
  final List<Vehicle> data;

  InstantRideVehicleSuccess({required this.data});
}
