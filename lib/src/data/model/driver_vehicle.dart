class DriverVehicle {
  late String chassis;
  late String color;
  late String engine;
  late String registrationNo;
  late String? interiorPhoto;
  late String? frontPhoto;
  late String vehicleType;


  DriverVehicle(this.chassis, this.color, this.engine, this.registrationNo, this.interiorPhoto, this.frontPhoto, this.vehicleType);

  Map<String, dynamic> get toMap => {
        "chassis": chassis,
        "color": color,
        "engine": engine,
        "registrationNo": registrationNo,
        "interiorPhoto": interiorPhoto ?? "",
        "frontPhoto": frontPhoto ?? "",
        "vehicleType": vehicleType,
      };

  DriverVehicle.fromMap(Map<String, dynamic> map) {
    chassis = map["chassis"];
    color = map["color"];
    engine = map["engine"];
    registrationNo = map["registrationNo"];
    interiorPhoto = map["interiorPhoto"] ?? "";
    frontPhoto = map["frontPhoto"] ?? "";
    vehicleType = map["vehicleType"];
  }
}
