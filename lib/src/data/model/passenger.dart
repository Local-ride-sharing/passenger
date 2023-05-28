import 'package:tmoto_passenger/src/utils/enums.dart';

class Passenger {
  late String reference;
  late String name;
  late Gender gender;
  late int dob;
  late String phone;
  late String? profilePicture;
  late bool isActive;
  late String? token;

  Passenger(
      this.reference, this.name, this.gender, this.dob, this.phone, this.profilePicture, this.token, this.isActive);

  Map<String, dynamic> get toMap => {
        "reference": reference,
        "name": name,
        "gender": gender.index,
        "dob": dob,
        "phone": phone,
        "profilePicture": profilePicture,
        "isActive": isActive,
        "token": token,
      };

  Passenger.fromMap(Map<String, dynamic> map) {
    reference = map["reference"];
    name = map["name"];
    dob = map["dob"];
    gender = Gender.values.elementAt(map["gender"]);
    phone = map["phone"];
    profilePicture = map["profilePicture"];
    isActive = map["isActive"];
    token = map["token"] ?? "";
  }
}
