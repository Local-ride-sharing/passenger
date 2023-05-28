part of 'point_vehicle_cubit.dart';

@immutable
abstract class PointVehicleState {}

class PointVehicleInitial extends PointVehicleState {}

class PointVehicleError extends PointVehicleState {
  final String error;

  PointVehicleError({required this.error});
}

class PointVehicleNetworking extends PointVehicleState {}

class PointVehicleSuccess extends PointVehicleState {
  final List<Vehicle> data;

  PointVehicleSuccess({required this.data});
}
