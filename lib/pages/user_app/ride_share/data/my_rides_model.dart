class MyRidesResponseModel {
  MyRidesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<MyRides> data;

  factory MyRidesResponseModel.fromJson(Map<String, dynamic> json) {
    return MyRidesResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<MyRides>.from(json["data"]!.map((x) => MyRides.fromJson(x))),
    );
  }
}

class MyRides {
  MyRides({
    required this.id,
    required this.vehicleNumber,
    required this.modelName,
    required this.seatCapacity,
    required this.registrationDoc,
    required this.aadharCard,
    required this.drivingLicense,
    required this.approved,
    required this.createdAt,
  });

  final int? id;
  final String? vehicleNumber;
  final String? modelName;
  final int? seatCapacity;
  final String? registrationDoc;
  final String? aadharCard;
  final String? drivingLicense;
  final bool? approved;
  final String? createdAt;

  factory MyRides.fromJson(Map<String, dynamic> json) {
    return MyRides(
      id: json["id"],
      vehicleNumber: json["vehicle_number"],
      modelName: json["model_name"],
      seatCapacity: json["seat_capacity"],
      registrationDoc: json["registration_doc"],
      aadharCard: json["aadhar_card"],
      drivingLicense: json["driving_license"],
      approved: json["approved"],
      createdAt: json["created_at"],
    );
  }
}
