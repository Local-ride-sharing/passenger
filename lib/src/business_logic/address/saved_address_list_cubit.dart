import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/repository/repository_saved_address.dart';

part 'saved_address_list_state.dart';

class SavedAddressCubit extends Cubit<SavedAddressState> {
  late SavedAddressRepository _repo;

  SavedAddressCubit() : super(SavedAddressInitial()) {
    _repo = SavedAddressRepository();
  }

  void monitorAddress(String reference) {
    emit(SavedAddressNetworking());
    _repo.monitorAddress(reference).listen((data) {
      parseSavedAddress(data);
    });
  }

  void parseSavedAddress(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      emit(SavedAddressSuccess(data: data.docs.map((item) => SavedAddress.fromMap(item.id, item.data())).toList()));
    } catch (error) {
      emit(SavedAddressError(error: "Something went wrong"));
    }
  }
}
