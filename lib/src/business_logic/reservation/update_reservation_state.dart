part of 'update_reservation_cubit.dart';


@immutable
abstract class UpdateReservationState {}

class UpdateReservationInitial extends UpdateReservationState {}

class UpdateReservationError extends UpdateReservationState {
  final String error;

  UpdateReservationError({required this.error});
}

class UpdateReservationNetworking extends UpdateReservationState {}

class UpdateReservationSuccess extends UpdateReservationState {
}

