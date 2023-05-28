part of 'delete_address_cubit.dart';

@immutable
abstract class DeleteAddressState {}

class DeleteAddressInitial extends DeleteAddressState {}

class DeleteAddressError extends DeleteAddressState {
  final String error;

  DeleteAddressError({required this.error});
}

class DeleteAddressNetworking extends DeleteAddressState {}

class DeleteAddressSuccess extends DeleteAddressState {}
