import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/saved_address.dart';
import 'package:tmoto_passenger/src/data/repository/repository_saved_address.dart';

part 'create_address_state.dart';

class CreateAddressCubit extends Cubit<CreateAddressState> {
  late SavedAddressRepository _repo;

  CreateAddressCubit() : super(CreateAddressInitial()) {
    _repo = SavedAddressRepository();
  }

  void createAddress(SavedAddress savedAddress) async {
    emit(CreateAddressNetworking());
    final String? result = await _repo.createSaveAddress(savedAddress);
    if (result == null) {
      emit(CreateAddressError(error: "Something went wrong"));
    } else {
      emit(CreateAddressSuccess(data: result));
    }
  }
}
