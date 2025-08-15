class MyVehicleDetailsModel {
  final String? vehicleName;
  final String? vehicleType;
  final String? registrationNumber;
  final int? seatingCapacity;
  final String? fuelType;
  final String? transmission;
  final String? securityDeposite;
  final String? rentalPricePerHour;
  final DateTime? availableFromDate;
  final DateTime? availableToDate;
  final String? pickupLocation;
  final String? vehiclePapersDocument;
  final bool? confirmationChecked;
  final String? vehicleColor;
  final bool? isAc;
  final bool? isAvailable;
  final int? bagCapacity;
  final bool? isApproved;
  final List<Image> images;

  MyVehicleDetailsModel({
    required this.vehicleName,
    required this.vehicleType,
    required this.registrationNumber,
    required this.seatingCapacity,
    required this.fuelType,
    required this.transmission,
    required this.securityDeposite,
    required this.rentalPricePerHour,
    required this.availableFromDate,
    required this.availableToDate,
    required this.pickupLocation,
    required this.vehiclePapersDocument,
    required this.confirmationChecked,
    required this.vehicleColor,
    required this.isAc,
    required this.isAvailable,
    required this.bagCapacity,
    required this.isApproved,
    required this.images,
  });

  factory MyVehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyVehicleDetailsModel(
      vehicleName: json["vehicle_name"],
      vehicleType: json["vehicle_type"],
      registrationNumber: json["registration_number"],
      seatingCapacity: json["seating_capacity"],
      fuelType: json["fuel_type"],
      transmission: json["transmission"],
      securityDeposite: json["security_deposite"],
      rentalPricePerHour: json["rental_price_per_hour"],
      availableFromDate: DateTime.tryParse(json["available_from_date"] ?? ""),
      availableToDate: DateTime.tryParse(json["available_to_date"] ?? ""),
      pickupLocation: json["pickup_location"],
      vehiclePapersDocument: json["vehicle_papers_document"],
      confirmationChecked: json["confirmation_checked"],
      vehicleColor: json["vehicle_color"],
      isAc: json["is_ac"],
      isAvailable: json["is_available"],
      bagCapacity: json["bag_capacity"],
      isApproved: json["is_approved"],
      images: json["images"] == null
          ? []
          : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    );
  }
}

class Image {
  final int? id;
  final String? image;
  final DateTime? uploadedAt;

  Image({required this.id, required this.image, required this.uploadedAt});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      image: json["image"],
      uploadedAt: DateTime.tryParse(json["uploaded_at"] ?? ""),
    );
  }
}
