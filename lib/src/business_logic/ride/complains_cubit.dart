import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/complains.dart';
import 'package:tmoto_passenger/src/data/repository/repository_complains.dart';

part 'complains_state.dart';

class ComplainsCubit extends Cubit<ComplainsState> {
  late ComplainsRepository _repo;

  ComplainsCubit() : super(ComplainsInitial()) {
    _repo = ComplainsRepository();
  }

  void monitorComplains() {
    emit(ComplainsNetworking());
    _repo.monitorComplains.listen((data) {
      parseReasons(data);
    });
  }

  void parseReasons(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Complains> results = data.docs.map((item) => Complains.fromMap(item.id, item.data())).toList();
      emit(ComplainsSuccess(data: results));
    } catch (error) {
      emit(ComplainsError(error: "Something went wrong"));
    }
  }
}
