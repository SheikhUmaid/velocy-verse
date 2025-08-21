class RentalModel {
  RentalModel({
    required this.id,
    required this.vehicleName,
    required this.registrationNumber,
    required this.vehicleColor,
    required this.isApproved,
    required this.images,
    required this.isAvailable,
  });

  final int? id;
  final String? vehicleName;
  final String? registrationNumber;
  final String? vehicleColor;
  final bool? isApproved;
  final List<String> images;
  final bool? isAvailable;

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json["id"],
      vehicleName: json["vehicle_name"],
      registrationNumber: json["registration_number"],
      vehicleColor: json["vehicle_color"],
      isApproved: json["is_approved"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      isAvailable: json["is_available"],
    );
  }
}
