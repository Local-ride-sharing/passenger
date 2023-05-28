import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/data/repository/repository_reservation.dart';

part 'bidding_state.dart';

class BiddingCubit extends Cubit<BiddingState> {
  late ReservationRepository _repo;

  BiddingCubit() : super(BiddingInitial()) {
    _repo = ReservationRepository();
  }

  void monitor(String reference) {
    emit(BiddingNetworking());
    _repo.monitorBidding(reference).listen((data) {
      parse(data);
    });
  }

  void parse(DocumentSnapshot<Map<String, dynamic>> data) {
    try {
      final Reservation reservation = Reservation.fromMap(data.id, data.data() ?? {});
      emit(BiddingSuccess(data: reservation));
    } catch (error) {
      emit(BiddingError(error: error.toString()));
    }
  }
}
