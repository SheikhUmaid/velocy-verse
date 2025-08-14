class RentalVehicleOwnerInfoModel {
  final String? vehicleName;
  final String? registrationNumber;
  final String? rentalPricePerHour;
  final String? vehicleColor;
  final String? vehiclePapersDocument;
  final User? user;
  final List<String> images;

  RentalVehicleOwnerInfoModel({
    required this.vehicleName,
    required this.registrationNumber,
    required this.rentalPricePerHour,
    required this.vehicleColor,
    required this.vehiclePapersDocument,
    required this.user,
    required this.images,
  });

  factory RentalVehicleOwnerInfoModel.fromJson(Map<String, dynamic> json) {
    return RentalVehicleOwnerInfoModel(
      vehicleName: json["vehicle_name"],
      registrationNumber: json["registration_number"],
      rentalPricePerHour: json["rental_price_per_hour"],
      vehicleColor: json["vehicle_color"],
      vehiclePapersDocument: json["vehicle_papers_document"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
    );
  }
}

class User {
  final int? id;
  final String? username;
  final String? phoneNumber;
  final String? profile;
  final String? aadharCard;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.profile,
    required this.aadharCard,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      phoneNumber: json["phone_number"],
      profile: json["profile"],
      aadharCard: json["aadhar_card"],
    );
  }
}
