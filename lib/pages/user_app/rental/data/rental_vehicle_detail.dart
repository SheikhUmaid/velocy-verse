class RentalVehicleDetailModel {
  final int? id;
  final String? vehicleName;
  final String? vehicleType;
  final String? rentalPricePerHour;
  final int? seatingCapacity;
  final bool? isAc;
  final String? fuelType;
  final String? transmission;
  final String? pickupLocation;
  final List<String> images;
  final dynamic averageRating;
  final User? user;

  RentalVehicleDetailModel({
    required this.id,
    required this.vehicleName,
    required this.vehicleType,
    required this.rentalPricePerHour,
    required this.seatingCapacity,
    required this.isAc,
    required this.fuelType,
    required this.transmission,
    required this.pickupLocation,
    required this.images,
    required this.averageRating,
    required this.user,
  });
  factory RentalVehicleDetailModel.fromJson(Map<String, dynamic> json) {
    return RentalVehicleDetailModel(
      id: json["id"],
      vehicleName: json["vehicle_name"],
      vehicleType: json["vehicle_type"],
      rentalPricePerHour: json["rental_price_per_hour"],
      seatingCapacity: json["seating_capacity"],
      isAc: json["is_ac"],
      fuelType: json["fuel_type"],
      transmission: json["transmission"],
      pickupLocation: json["pickup_location"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      averageRating: json["average_rating"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }
}

class User {
  final int? id;
  final String? username;
  final String? profile;

  User({required this.id, required this.username, required this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      profile: json["profile"],
    );
  }
}
