part of 'existence_cubit.dart';

@immutable
abstract class ExistenceState {}

class ExistenceInitial extends ExistenceState {}

class ExistenceError extends ExistenceState {
  final String error;

  ExistenceError(this.error);
}

class ExistenceNetworking extends ExistenceState {}

class ExistenceSuccess extends ExistenceState {
  final bool exists;
  final Passenger? passenger;

  ExistenceSuccess({required this.exists, required this.passenger});
}
