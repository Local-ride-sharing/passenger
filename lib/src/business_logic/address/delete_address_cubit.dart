import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/repository/repository_saved_address.dart';

part 'delete_address_state.dart';

class DeleteAddressCubit extends Cubit<DeleteAddressState> {
  late SavedAddressRepository _repo;

  DeleteAddressCubit() : super(DeleteAddressInitial()) {
    _repo = SavedAddressRepository();
  }

  void deleteAddress(String reference) async {
    emit(DeleteAddressNetworking());
    _repo.deleteAddress(reference).then((response) {
      if (response != null) {
        emit(DeleteAddressSuccess());
      } else {
        emit(DeleteAddressError(error: "Address deletion interrupted unexpectedly"));
      }
    });
  }
}
