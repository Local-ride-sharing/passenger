import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:passenger/src/data/repository/repository_login.dart';

part 'verify_otp_state.dart';

class VerifyOTPCubit extends Cubit<VerifyOTPState> {
  late LoginRepository _repo;
  VerifyOTPCubit() : super(VerifyOTPInitial()) {
    _repo = LoginRepository();
  }

  void verifyOTP(String code, String verificationId) {
    emit(VerifyOTPNetworking());
    _repo.verifyOTPCode(code, verificationId).then((reference) {
      if (reference != null) {
        emit(VerifyOTPSuccess(reference));
      } else {
        emit(VerifyOTPError("Something went wrong"));
      }
    });
  }

  void verifyOTPWithCredential(PhoneAuthCredential credential) {
    emit(VerifyOTPNetworking());
    _repo.verifyOTPCodeWithCredential(credential).then((reference) {
      if (reference != null) {
        emit(VerifyOTPSuccess(reference));
      } else {
        emit(VerifyOTPError("Something went wrong"));
      }
    });
  }
}
