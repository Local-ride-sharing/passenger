part of 'find_single_driver_cubit.dart';

@immutable
abstract class FindSingleDriverState {}

class FindSingleDriverInitial extends FindSingleDriverState {}

class FindSingleDriverError extends FindSingleDriverState {
  final String error;

  FindSingleDriverError({required this.error});
}

class FindSingleDriverNetworking extends FindSingleDriverState {}

class FindSingleDriverSuccess extends FindSingleDriverState {
  final Driver data;

  FindSingleDriverSuccess({required this.data});
}
