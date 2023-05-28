part of 'direction_cubit.dart';

@immutable
abstract class DirectionState {}

class DirectionInitial extends DirectionState {}
class DirectionError extends DirectionState {
  final String error;

  DirectionError({required this.error});
}
class DirectionNetworking extends DirectionState {}
class DirectionSuccess extends DirectionState {
  final Direction data;

  DirectionSuccess({required this.data});
}
