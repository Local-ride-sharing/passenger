part of 'reservations_cubit.dart';


@immutable
abstract class ReservationsState {}

class ReservationsInitial extends ReservationsState {}

class ReservationsError extends ReservationsState {
  final String error;

  ReservationsError({required this.error});
}

class ReservationsNetworking extends ReservationsState {}

class ReservationsSuccess extends ReservationsState {
  final List<Reservation> data;

  ReservationsSuccess({required this.data});
}
