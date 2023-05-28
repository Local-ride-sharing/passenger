part of 'reservation_vehicle_cubit.dart';

@immutable
abstract class ReservationVehicleState {}

class ReservationVehicleInitial extends ReservationVehicleState {}

class ReservationVehicleError extends ReservationVehicleState {
  final String error;

  ReservationVehicleError({required this.error});
}

class ReservationVehicleNetworking extends ReservationVehicleState {}

class ReservationVehicleSuccess extends ReservationVehicleState {
  final List<Vehicle> data;

  ReservationVehicleSuccess({required this.data});
}
