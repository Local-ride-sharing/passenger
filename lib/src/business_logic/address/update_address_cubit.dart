import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/saved_address.dart';
import 'package:tmoto_passenger/src/data/repository/repository_saved_address.dart';

part 'update_address_state.dart';

class UpdateAddressCubit extends Cubit<UpdateAddressState> {
  late SavedAddressRepository _repo;

  UpdateAddressCubit() : super(UpdateAddressInitial()) {
    _repo = SavedAddressRepository();
  }

  void updateAddress(SavedAddress savedAddress) async {
    emit(UpdateAddressNetworking());
    final String? result = await _repo.updateSaveAddress(savedAddress);
    if (result == null) {
      emit(UpdateAddressError(error: "Something went wrong"));
    } else {
      emit(UpdateAddressSuccess(data: result));
    }
  }

  void deleteAddress(String savedAddress) async {
    emit(UpdateAddressNetworking());
    final String? result = await _repo.deleteAddress(savedAddress);
    if (result == null) {
      emit(UpdateAddressError(error: "Something went wrong"));
    } else {
      emit(UpdateAddressSuccess(data: result));
    }
  }
}
