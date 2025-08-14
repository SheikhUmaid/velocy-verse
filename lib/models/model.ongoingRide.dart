class OngoingRide_Model {
  OngoingRide_Model({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
    required this.otpVerified,
    required this.rider,
  });

  final int? id;
  final String? fromLocation;
  final String? toLocation;
  final String? status;
  final bool? otpVerified;
  final Rider? rider;

  factory OngoingRide_Model.fromJson(Map<String, dynamic> json) {
    return OngoingRide_Model(
      id: json["id"],
      fromLocation: json["from_location"],
      toLocation: json["to_location"],
      status: json["status"],
      otpVerified: json["otp_verified"],
      rider: json["rider"] == null ? null : Rider.fromJson(json["rider"]),
    );
  }
}

class Rider {
  Rider({
    required this.username,
    required this.phoneNumber,
    required this.profile,
  });

  final String? username;
  final String? phoneNumber;
  final String? profile;

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      username: json["username"],
      phoneNumber: json["phone_number"],
      profile: json["profile"],
    );
  }
}
