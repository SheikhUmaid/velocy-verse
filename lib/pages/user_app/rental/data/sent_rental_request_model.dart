class SentRentalRequestModel {
  final int? id;
  final String? status;
  final String? lessorUsername;
  final String? vehicleName;
  final String? registrationNumber;
  final String? pickup;
  final String? dropoff;
  final int? durationHours;

  SentRentalRequestModel({
    required this.id,
    required this.status,
    required this.lessorUsername,
    required this.vehicleName,
    required this.registrationNumber,
    required this.pickup,
    required this.dropoff,
    required this.durationHours,
  });

  factory SentRentalRequestModel.fromJson(Map<String, dynamic> json) {
    return SentRentalRequestModel(
      id: json["id"],
      status: json["status"],
      lessorUsername: json["lessor_username"],
      vehicleName: json["vehicle_name"],
      registrationNumber: json["registration_number"],
      pickup: json["pickup"],
      dropoff: json["dropoff"],
      durationHours: json["duration_hours"],
    );
  }
}
