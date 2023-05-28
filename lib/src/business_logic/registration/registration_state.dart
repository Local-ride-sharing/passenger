part of 'registration_cubit.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String error;

  RegistrationError({required this.error});
}

class RegistrationNetworking extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}
