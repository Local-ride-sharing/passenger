import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tmoto_passenger/src/data/model/saved_address.dart';
import 'package:tmoto_passenger/src/data/service/service_save_address.dart';

class SavedAddressRepository {
  late SavedAddressService _service;
  Map<String, SavedAddress> results = HashMap<String, SavedAddress>();

  SavedAddressRepository() {
    _service = SavedAddressService();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> monitorAddress(String reference) => _service.monitorSavedAddress(reference);

  Future<String?> createSaveAddress(SavedAddress savedAddress) async {
    return await _service.createSavedAddress(savedAddress);
  }

  Future<String?> updateSaveAddress(SavedAddress savedAddress) async {
    return await _service.updateSavedAddress(savedAddress);
  }

  Future<String?> deleteAddress(String savedAddressReference) async {
    return await _service.deleteAddress(savedAddressReference);
  }
}
