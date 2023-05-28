part of 'find_driver_cubit.dart';

@immutable
abstract class FindDriverState {}

class FindDriverInitial extends FindDriverState {}

class FindDriverError extends FindDriverState {
  final String error;

  FindDriverError({required this.error});
}

class FindDriverNetworking extends FindDriverState {}

class FindDriverSuccess extends FindDriverState {
  final List<Driver> data;

  FindDriverSuccess({required this.data});
}
