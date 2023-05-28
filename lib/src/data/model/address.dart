class Address {
  late String label;
  late double latitude;
  late double longitude;

  Address({required this.label, required this.latitude, required this.longitude});

  Map<String, dynamic> get toMap => {
        "label": label,
        "latitude": latitude,
        "longitude": longitude,
      };

  Address.fromMap(Map<String, dynamic> map) {
    label = map["label"] ?? "";
    latitude = map["latitude"] ?? 0;
    longitude = map["longitude"] ?? 0;
  }
}
