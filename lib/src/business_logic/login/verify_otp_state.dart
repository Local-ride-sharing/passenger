part of 'verify_otp_cubit.dart';

@immutable
abstract class VerifyOTPState {}

class VerifyOTPInitial extends VerifyOTPState {}

class VerifyOTPError extends VerifyOTPState {
  final String error;

  VerifyOTPError(this.error);
}

class VerifyOTPNetworking extends VerifyOTPState {}

class VerifyOTPSuccess extends VerifyOTPState {
  final String reference;

  VerifyOTPSuccess(this.reference);
}
