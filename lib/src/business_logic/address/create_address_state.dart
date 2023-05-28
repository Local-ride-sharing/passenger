part of 'create_address_cubit.dart';

@immutable
abstract class CreateAddressState {}

class CreateAddressInitial extends CreateAddressState {}

class CreateAddressError extends CreateAddressState {
  final String error;

  CreateAddressError({required this.error});
}

class CreateAddressNetworking extends CreateAddressState {}

class CreateAddressSuccess extends CreateAddressState {
  final String data;

  CreateAddressSuccess({required this.data});
}
