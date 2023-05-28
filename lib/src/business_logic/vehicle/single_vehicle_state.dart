part of 'single_vehicle_cubit.dart';

@immutable
abstract class SingleVehicleState {}

class SingleVehicleInitial extends SingleVehicleState {}

class SingleVehicleError extends SingleVehicleState {
  final String error;

  SingleVehicleError({required this.error});
}

class SingleVehicleNetworking extends SingleVehicleState {}

class SingleVehicleSuccess extends SingleVehicleState {
  final Vehicle data;

  SingleVehicleSuccess({required this.data});
}
