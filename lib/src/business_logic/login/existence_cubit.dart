import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/repository/repository_login.dart';

part 'existence_state.dart';

class ExistenceCubit extends Cubit<ExistenceState> {
  late LoginRepository _repo;

  ExistenceCubit() : super(ExistenceInitial()) {
    _repo = LoginRepository();
  }

  void check() {
    emit(ExistenceNetworking());
    _repo.checkExistence.then((response) {
      if (response.success) {
        emit(ExistenceSuccess(exists: response.result!=null, passenger: response.result));
      } else {
        emit(ExistenceError(response.error ?? "something went wrong"));
      }
    });
  }
}
