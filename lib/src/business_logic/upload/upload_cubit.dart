import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmoto_passenger/src/data/repository/repository_registration.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  late RegistrationRepository _repo;

  UploadCubit() : super(UploadInitial()) {
    _repo = RegistrationRepository();
  }

  void upload(String reference, String filePath) {
    emit(UploadNetworking());
    _repo.upload(reference, filePath).then((response) {
      if (response.success) {
        if (response.result != null) {
          emit(UploadSuccess(data: response.result!));
        } else {
          emit(UploadError(error: response.error ?? "Unexpected error occurred"));
        }
      } else {
        emit(UploadError(error: response.error ?? "Something went wrong"));
      }
    });
  }
}
