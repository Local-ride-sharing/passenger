import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/service/service_registration.dart';
import 'package:passenger/src/utils/network_response.dart';

class RegistrationRepository {
  late RegistrationService _service;

  RegistrationRepository() {
    _service = RegistrationService();
  }

  Future<NetworkResponse<String?>> upload(String reference, String filePath) async {
    return await _service.upload(reference, filePath);
  }

  Future<NetworkResponse<void>> update(Passenger passenger) async {
    return await _service.update(passenger);
  }
}
