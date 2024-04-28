import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/repository/repository_registration.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  late RegistrationRepository _repo;

  UpdateCubit() : super(UpdateInitial()) {
    _repo = RegistrationRepository();
  }

  void update(Passenger passenger) async {
    emit(UpdateNetworking());
    _repo.update(passenger).then((response) {
      if (response.success) {
        emit(UpdateSuccess());
      } else {
        emit(UpdateError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
