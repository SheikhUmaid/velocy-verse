class DriverDetailsModel {
  DriverDetailsModel({
    required this.username,
    required this.email,
    required this.profileImage,
    required this.vehicleInfo,
  });

  final String? username;
  final dynamic email;
  final String? profileImage;
  final VehicleInfo? vehicleInfo;

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      username: json["username"],
      email: json["email"] == null ? '' : json["email"],
      profileImage: json["profile_image"],
      vehicleInfo: json["vehicle_info"] == null
          ? null
          : VehicleInfo.fromJson(json["vehicle_info"]),
    );
  }
}

class VehicleInfo {
  VehicleInfo({
    required this.id,
    required this.vehicleNumber,
    required this.carName,
  });

  final int? id;
  final String? vehicleNumber;
  final String? carName;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json["id"],
      vehicleNumber: json["vehicle_number"],
      carName: json["car_name"],
    );
  }
}
