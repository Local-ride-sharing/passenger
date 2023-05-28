part of 'single_driver_cubit.dart';

@immutable
abstract class SingleDriverState {}

class SingleDriverInitial extends SingleDriverState {}

class SingleDriverError extends SingleDriverState {
  final String error;

  SingleDriverError({required this.error});
}

class SingleDriverNetworking extends SingleDriverState {}

class SingleDriverSuccess extends SingleDriverState {
  final Driver data;

  SingleDriverSuccess({required this.data});
}
