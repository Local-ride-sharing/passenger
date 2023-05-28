part of 'cancel_ride_cubit.dart';

@immutable
abstract class CancelRideState {}

class CancelRideInitial extends CancelRideState {}

class CancelRideError extends CancelRideState {
  final String error;

  CancelRideError({required this.error});
}

class CancelRideNetworking extends CancelRideState {}

class CancelRideSuccess extends CancelRideState {}
