part of 'my_trips_list_cubit.dart';

@immutable
abstract class MyTripsState {}

class MyTripsInitial extends MyTripsState {}

class MyTripsError extends MyTripsState {
  final String error;

  MyTripsError({required this.error});
}

class MyTripsNetworking extends MyTripsState {}

class MyTripsSuccess extends MyTripsState {
  final List<Ride> completed;
  final List<Ride> canceled;

  MyTripsSuccess({required this.completed, required this.canceled});
}
