import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/reservation.dart';
import 'package:passenger/src/data/repository/repository_reservation.dart';

part 'reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  late ReservationRepository _repo;

  ReservationsCubit() : super(ReservationsInitial()) {
    _repo = ReservationRepository();
  }

  void monitor(String reference) {
    emit(ReservationsNetworking());
    _repo.monitor(reference).listen((event) {
      parse(event);
    });
  }

  void parse(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Reservation> reservations = [];
      data.docs.forEach((element) {
        reservations.add(Reservation.fromMap(element.id, element.data()));
      });
      reservations.sort((b, a) => (a.biddingDeadline).compareTo(b.biddingDeadline));
      emit(ReservationsSuccess(data: reservations));
    } catch (error) {
      emit(ReservationsError(error: error.toString()));
    }
  }
}
