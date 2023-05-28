part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});
}

class ProfileNetworking extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Passenger data;

  ProfileSuccess({required this.data});
}
