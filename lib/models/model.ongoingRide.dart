class OngoingRide_Model {
  OngoingRide_Model({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
    required this.otpVerified,
  });

  final int? id;
  final String? fromLocation;
  final String? toLocation;
  final String? status;
  final bool? otpVerified;

  factory OngoingRide_Model.fromJson(Map<String, dynamic> json) {
    return OngoingRide_Model(
      id: json["id"],
      fromLocation: json["from_location"],
      toLocation: json["to_location"],
      status: json["status"],
      otpVerified: json["otp_verified"],
    );
  }
}
