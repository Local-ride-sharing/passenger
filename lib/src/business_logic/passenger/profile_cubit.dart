import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/repository/repository_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  late ProfileRepository _repo;

  ProfileCubit() : super(ProfileInitial()) {
    _repo = ProfileRepository();
  }

  void monitor(String reference) {
    emit(ProfileNetworking());
    _repo.monitorProfile(reference).listen((data) {
      parse(data);
    });
  }

  void parse(DocumentSnapshot<Map<String, dynamic>> data) {
    try {
      final String reference = data.id;
      final Map<String, dynamic> map = data.data() ?? {};
      map.addAll({"reference": reference});
      emit(ProfileSuccess(data: Passenger.fromMap(map)));
    } catch (error) {
      emit(ProfileError(error: error.toString()));
    }
  }
}
