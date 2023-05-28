import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';

class SavedAddress {
  late String reference;
  late String passengerReference;
  late AddressType addressType;
  late String label;
  late double latitude;
  late double longitude;

  SavedAddress(this.reference, this.passengerReference, this.addressType, this.label, this.latitude,
      this.longitude);

  Map<String, dynamic> get toMap => {
        "passengerReference": passengerReference,
        "addressType": addressType.index,
        "label": label,
        "latitude": latitude,
        "longitude": longitude,
      };

  SavedAddress.fromMap(String ref, Map<String, dynamic> map) {
    reference = ref;
    addressType = AddressType.values.elementAt(map["addressType"]);
    passengerReference = map["passengerReference"];
    label = map["label"];
    latitude = map["latitude"];
    longitude = map["longitude"];
  }

  Address get address => Address(label: label, latitude: latitude, longitude: longitude);
}
