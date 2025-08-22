class ReceivedRentalRequestsModel {
  final int? id;
  final String? username;
  final String? userProfile;
  final String? phoneNumber;
  final String? vehicleName;
  final String? registrationNumber;
  final String? vehicleColor;
  final String? status;

  ReceivedRentalRequestsModel({
    required this.id,
    required this.username,
    required this.userProfile,
    required this.phoneNumber,
    required this.vehicleName,
    required this.registrationNumber,
    required this.vehicleColor,
    required this.status,
  });

  factory ReceivedRentalRequestsModel.fromJson(Map<String, dynamic> json) {
    return ReceivedRentalRequestsModel(
      id: json["id"],
      username: json["username"],
      userProfile: json["user_profile"],
      phoneNumber: json["phone_number"],
      vehicleName: json["vehicle_name"],
      registrationNumber: json["registration_number"],
      vehicleColor: json["vehicle_color"],
      status: json["status"],
    );
  }
}
