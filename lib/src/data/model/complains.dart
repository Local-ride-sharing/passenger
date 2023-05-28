class Complains {
  late String reference;
  late String enComplain;
  late String bnComplain;
  late bool isActive;

  Complains(this.reference, this.enComplain, this.bnComplain, this.isActive);

  Map<String, dynamic> get toMap => {
        "enComplain": enComplain,
        "bnComplain": bnComplain,
        "isActive": isActive,
      };

  Complains.fromMap(String ref, Map<String, dynamic> map) {
    reference = ref;
    enComplain = map["enComplain"];
    bnComplain = map["bnComplain"];
    isActive = map["isActive"] ?? false;
  }
}
