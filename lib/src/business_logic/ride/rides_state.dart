part of 'rides_cubit.dart';

@immutable
abstract class RidesState {}

class RidesInitial extends RidesState {}

class RidesError extends RidesState {
  final String error;

  RidesError({required this.error});
}

class RidesNetworking extends RidesState {}

class RidesSuccess extends RidesState {
  final List<Ride> data;

  RidesSuccess({required this.data});
}
