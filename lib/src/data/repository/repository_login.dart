import 'package:firebase_auth/firebase_auth.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/service/service_login.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class LoginRepository {
  late LoginService _service;

  LoginRepository() {
    _service = LoginService();
  }

  Future<String?> verifyOTPCode(String code, String verificationId) async {
    return await _service.verifyOTPCode(code, verificationId);
  }

  Future<String?> verifyOTPCodeWithCredential(PhoneAuthCredential credential) async {
    return await _service.verifyOTPCodeWithCredential(credential);
  }

  Future<NetworkResponse<Passenger?>> get checkExistence async {
    return await _service.checkExistence;
  }
}
