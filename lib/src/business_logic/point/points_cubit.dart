import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/model/point.dart';
import 'package:tmoto_passenger/src/data/repository/repository_point.dart';

part 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  late PointRepository _repo;

  PointsCubit() : super(PointsInitial()) {
    _repo = PointRepository();
  }

  void monitorPoints() {
    emit(PointsNetworking());
    _repo.monitorPoints.listen((data) {
      parsePoints(data);
    });
  }

  void parsePoints(QuerySnapshot<Map<String, dynamic>> data) {
    try {
      List<Point> results = data.docs.map((item) => Point.fromMap(item.id, item.data())).toList();
      emit(PointsSuccess(data: results));
    } catch (error) {
      print(error);
      emit(PointsError(error: "Something went wrong"));
    }
  }
}
