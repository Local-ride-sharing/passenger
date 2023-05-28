part of 'update_cubit.dart';

@immutable
abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateError extends UpdateState {
  final String error;

  UpdateError({required this.error});
}

class UpdateNetworking extends UpdateState {}

class UpdateSuccess extends UpdateState {}
