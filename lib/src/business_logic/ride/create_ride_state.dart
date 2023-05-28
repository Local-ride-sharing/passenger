part of 'create_ride_cubit.dart';

@immutable
abstract class CreateRideState {}

class CreateRideInitial extends CreateRideState {}

class CreateRideError extends CreateRideState {
  final String error;

  CreateRideError({required this.error});
}

class CreateRideNetworking extends CreateRideState {}

class CreateRideSuccess extends CreateRideState {
  final Ride data;

  CreateRideSuccess({required this.data});
}
