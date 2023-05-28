part of 'generate_otp_cubit.dart';

@immutable
abstract class GenerateOTPState {}

class GenerateOTPInitial extends GenerateOTPState {}

class GenerateOTPError extends GenerateOTPState {
  final String error;

  GenerateOTPError(this.error);
}

class GenerateOTPNetworking extends GenerateOTPState {}

class GenerateOTPSuccess extends GenerateOTPState {
  final PhoneAuthCredential? credential;
  final String verificationId;

  GenerateOTPSuccess(this.credential, this.verificationId);
}
