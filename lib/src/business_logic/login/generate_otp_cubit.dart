import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'generate_otp_state.dart';

class GenerateOTPCubit extends Cubit<GenerateOTPState> {
  GenerateOTPCubit() : super(GenerateOTPInitial());

  void generateOTP(String phone) {
    emit(GenerateOTPNetworking());
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        emit(GenerateOTPSuccess(credential, credential.verificationId ?? ""));
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(GenerateOTPError("Something went wrong"));
      },
      codeSent: (String id, int? resendToken) {
        emit(GenerateOTPSuccess(null, id));
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String id) {
        emit(GenerateOTPSuccess(null, id));
      },
    );
  }
}
