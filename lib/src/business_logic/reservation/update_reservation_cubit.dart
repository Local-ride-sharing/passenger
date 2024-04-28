import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/reservation.dart';
import 'package:passenger/src/data/repository/repository_reservation.dart';

part 'update_reservation_state.dart';

class UpdateReservationCubit extends Cubit<UpdateReservationState> {
  late ReservationRepository _repo;
  UpdateReservationCubit() : super(UpdateReservationInitial()) {
    _repo = ReservationRepository();
  }

  void update(Reservation reservation) {
    emit(UpdateReservationNetworking());
    _repo.update(reservation).then((response) {
      if (response.success) {
        emit(UpdateReservationSuccess());
      } else {
        emit(UpdateReservationError(error: response.error ?? "something went wrong"));
      }
    });
  }
}
