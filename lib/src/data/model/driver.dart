import 'package:tmoto_passenger/src/data/model/driver_location.dart';
import 'package:tmoto_passenger/src/data/model/driver_vehicle.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';

class Driver {
  late String reference;
  late String name;
  late String nid;
  late String drivingLicense;
  late String phone;
  late String profilePicture;
  late DriverLocation location;
  late DriverVehicle vehicle;
  late bool isActive;
  late String token;
  late Gender gender;

  Driver(this.reference, this.name, this.nid, this.drivingLicense, this.phone, this.profilePicture, this.location, this.vehicle, this.isActive,
      this.token, this.gender);

  Map<String, dynamic> get toMap => {
        "name": name,
        "nid": nid,
        "gender": gender.index,
        "phone": phone,
        "profilePicture": profilePicture,
        "drivingLicense": drivingLicense,
        "location": location.toMap,
        "vehicle": vehicle.toMap,
        "isActive": isActive,
        "token": token,
      };

  Driver.fromMap(String ref, Map<String, dynamic> map) {
    name = map["name"];
    nid = map["nid"];
    gender = Gender.values.elementAt(map["gender"]);
    phone = map["phone"];
    profilePicture = map["profilePicture"];
    drivingLicense = map["drivingLicense"] ?? "";
    location = DriverLocation.fromMap(map["location"]);
    vehicle = DriverVehicle.fromMap(map["vehicle"]);
    isActive = map["isActive"];
    token = map["token"] ?? "";
    reference = ref;
  }
}
