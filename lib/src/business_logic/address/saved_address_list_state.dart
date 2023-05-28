part of 'saved_address_list_cubit.dart';

@immutable
abstract class SavedAddressState {}

class SavedAddressInitial extends SavedAddressState {}

class SavedAddressError extends SavedAddressState {
  final String error;

  SavedAddressError({required this.error});
}

class SavedAddressNetworking extends SavedAddressState {}

class SavedAddressSuccess extends SavedAddressState {
  final List<SavedAddress> data;

  SavedAddressSuccess({required this.data});
}
