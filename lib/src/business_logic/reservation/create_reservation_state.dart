part of 'create_reservation_cubit.dart';

@immutable
abstract class CreateReservationState {}

class CreateReservationInitial extends CreateReservationState {}

class CreateReservationError extends CreateReservationState {
  final String error;

  CreateReservationError({required this.error});
}

class CreateReservationNetworking extends CreateReservationState {}

class CreateReservationSuccess extends CreateReservationState {}
