class LocationModel {
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;

  LocationModel({
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
