part of 'single_ride_cubit.dart';

@immutable
abstract class SingleRideState {}

class SingleRideInitial extends SingleRideState {}

class SingleRideError extends SingleRideState {
  final String error;

  SingleRideError({required this.error});
}

class SingleRideNetworking extends SingleRideState {}

class SingleRideSuccess extends SingleRideState {
  final Ride data;

  SingleRideSuccess({required this.data});
}
