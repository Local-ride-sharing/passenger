part of 'update_address_cubit.dart';

@immutable
abstract class UpdateAddressState {}

class UpdateAddressInitial extends UpdateAddressState {}

class UpdateAddressError extends UpdateAddressState {
  final String error;

  UpdateAddressError({required this.error});
}

class UpdateAddressNetworking extends UpdateAddressState {}

class UpdateAddressSuccess extends UpdateAddressState {
  final String data;

  UpdateAddressSuccess({required this.data});
}
