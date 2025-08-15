class VehiclesForRentModel {
  final int? id;
  final String? vehicleName;
  final String? vehicleType;
  final int? seatingCapacity;
  final String? rentalPricePerHour;
  final bool? isAvailable;
  final List<String> images;
  final int? bagCapacity;

  VehiclesForRentModel({
    required this.id,
    required this.vehicleName,
    required this.vehicleType,
    required this.seatingCapacity,
    required this.rentalPricePerHour,
    required this.isAvailable,
    required this.images,
    required this.bagCapacity,
  });

  factory VehiclesForRentModel.fromJson(Map<String, dynamic> json) {
    return VehiclesForRentModel(
      id: json["id"],
      vehicleName: json["vehicle_name"],
      vehicleType: json["vehicle_type"],
      seatingCapacity: json["seating_capacity"],
      rentalPricePerHour: json["rental_price_per_hour"],
      isAvailable: json["is_available"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      bagCapacity: json["bag_capacity"],
    );
  }
}
