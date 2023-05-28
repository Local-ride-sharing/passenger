import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/repository/repository_registration.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  late RegistrationRepository _repo;

  RegistrationCubit() : super(RegistrationInitial()) {
    _repo = RegistrationRepository();
  }

  void save(Passenger passenger) async {
    emit(RegistrationNetworking());
    _repo.update(passenger).then((response) {
      if (response.success) {
        emit(RegistrationSuccess());
      } else {
        emit(RegistrationError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
