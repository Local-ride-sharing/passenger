import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/repository/repository_driver.dart';

part 'find_single_driver_state.dart';

class FindSingleDriverCubit extends Cubit<FindSingleDriverState> {
  late DriverRepository _repo;

  FindSingleDriverCubit() : super(FindSingleDriverInitial()) {
    _repo = DriverRepository();
  }

  void findDriver(BuildContext context, String reference) {
    emit(FindSingleDriverNetworking());
    _repo.findDriver(context, reference).then((response) {
      if (response.success) {
        if (response.result != null) {
          emit(FindSingleDriverSuccess(data: response.result!));
        } else {
          emit(FindSingleDriverError(error: "Driver not found"));
        }
      } else {
        emit(FindSingleDriverError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
