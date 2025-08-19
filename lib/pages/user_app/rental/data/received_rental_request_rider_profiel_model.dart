class ReceivedRentalRequestsRiderProfileModel {
  final int? id;
  final String? username;
  final String? phoneNumber;
  final String? profile;
  final String? area;
  final String? street;
  final String? drivingLicense;
  final String? vehicleName;
  final String? aadharCard;

  ReceivedRentalRequestsRiderProfileModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.profile,
    required this.area,
    required this.street,
    required this.drivingLicense,
    required this.vehicleName,
    required this.aadharCard,
  });

  factory ReceivedRentalRequestsRiderProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReceivedRentalRequestsRiderProfileModel(
      id: json["id"],
      username: json["username"],
      phoneNumber: json["phone_number"],
      profile: json["profile"],
      area: json["area"],
      street: json["street"],
      drivingLicense: json["driving_license"],
      vehicleName: json["vehicle_name"],
      aadharCard: json["aadhar_card"],
    );
  }
}
