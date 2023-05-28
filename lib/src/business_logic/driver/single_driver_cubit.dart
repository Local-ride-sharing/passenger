import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/provider/provider_driver.dart';
import 'package:tmoto_passenger/src/data/repository/repository_driver.dart';

part 'single_driver_state.dart';

class SingleDriverCubit extends Cubit<SingleDriverState> {
  late DriverRepository _repo;

  SingleDriverCubit() : super(SingleDriverInitial()) {
    _repo = DriverRepository();
  }

  void monitorSingleDriver(BuildContext context, String reference) {
    emit(SingleDriverNetworking());

    try {
      _repo.monitorSingleDriver(reference).listen((data) {
        parse(context, data);
      });
    } catch (error) {
      emit(SingleDriverError(error: error.toString()));
    }
  }

  void parse(BuildContext context, DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final driverProvider = Provider.of<DriverProvider>(context, listen: false);
      final Driver driver = Driver.fromMap(snapshot.id, snapshot.data() ?? {});
      driverProvider.add(driver);
      emit(SingleDriverSuccess(data: driver));
    } catch (error) {
      emit(SingleDriverError(error: error.toString()));
    }
  }
}
