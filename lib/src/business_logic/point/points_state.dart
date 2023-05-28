part of 'points_cubit.dart';

@immutable
abstract class PointsState {}

class PointsInitial extends PointsState {}

class PointsError extends PointsState {
  final String error;

  PointsError({required this.error});
}

class PointsNetworking extends PointsState {
}

class PointsSuccess extends PointsState {
  final List<Point> data;

  PointsSuccess({required this.data});
}