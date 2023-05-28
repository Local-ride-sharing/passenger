part of 'complains_cubit.dart';

@immutable
abstract class ComplainsState {}

class ComplainsInitial extends ComplainsState {}

class ComplainsError extends ComplainsState {
  final String error;

  ComplainsError({required this.error});
}

class ComplainsNetworking extends ComplainsState {}

class ComplainsSuccess extends ComplainsState {
  final List<Complains> data;

  ComplainsSuccess({required this.data});
}
