import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/model/fare.dart';
import 'package:passenger/src/data/repository/repository_fare.dart';

part 'fare_list_state.dart';

class FareListCubit extends Cubit<FareListState> {
  late FareRepository _repo;

  FareListCubit() : super(FareListInitial()) {
    _repo = FareRepository();
  }

  void monitorFares() {
    emit(FareListNetworking());
    _repo.monitorFares.listen((data) {
      parseFares(data);
    });
  }

  void parseFares(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      emit(FareListSuccess(data: data.docs.map((item) => Fare.fromMap(item.id, item.data())).toList()));
    } catch (error) {
      emit(FareListError(error: "Something went wrong"));
    }
  }
}
