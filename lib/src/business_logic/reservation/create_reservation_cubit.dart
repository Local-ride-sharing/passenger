import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/reservation.dart';
import 'package:passenger/src/data/repository/repository_reservation.dart';

part 'create_reservation_state.dart';

class CreateReservationCubit extends Cubit<CreateReservationState> {
  late ReservationRepository _repo;

  CreateReservationCubit() : super(CreateReservationInitial()) {
    _repo = ReservationRepository();
  }

  void create(Reservation reservation) {
    emit(CreateReservationNetworking());
    _repo.create(reservation).then((response) {
      if (response.success) {
        emit(CreateReservationSuccess());
      } else {
        emit(CreateReservationError(error: response.error ?? "something went wrong"));
      }
    });
  }
}
