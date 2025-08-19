class SharedRideDetailsResponseModel {
  SharedRideDetailsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final RideShareDetails? data;

  factory SharedRideDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return SharedRideDetailsResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : RideShareDetails.fromJson(json["data"]),
    );
  }
}

class RideShareDetails {
  RideShareDetails({
    required this.rideDate,
    required this.passengerNotes,
    required this.rideCreator,
    required this.rideDetails,
    required this.coordinates,
    required this.otherPassengers,
  });

  final DateTime? rideDate;
  final String? passengerNotes;
  final RideCreator? rideCreator;
  final RideDetails? rideDetails;
  final Coordinates? coordinates;
  final List<OtherPassengers> otherPassengers;

  factory RideShareDetails.fromJson(Map<String, dynamic> json) {
    return RideShareDetails(
      rideDate: DateTime.tryParse(json["ride_date"] ?? ""),
      passengerNotes: json["passenger_notes"],
      rideCreator: json["ride_creator"] == null
          ? null
          : RideCreator.fromJson(json["ride_creator"]),
      rideDetails: json["ride_details"] == null
          ? null
          : RideDetails.fromJson(json["ride_details"]),
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
      otherPassengers: json["other_passengers"] == null
          ? []
          : List<OtherPassengers>.from(
              json["other_passengers"].map((x) => OtherPassengers.fromJson(x)),
            ),
    );
  }
}

class Coordinates {
  Coordinates({
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
  });

  final double? fromLat;
  final double? fromLng;
  final double? toLat;
  final double? toLng;

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      fromLat: json["from_lat"],
      fromLng: json["from_lng"],
      toLat: json["to_lat"],
      toLng: json["to_lng"],
    );
  }
}

class RideCreator {
  RideCreator({
    required this.username,
    required this.phoneNumber,
    required this.profileImage,
    required this.avgRating,
    required this.vehicleName,
    required this.ratingUserCount,
    required this.cancellationProbability,
  });

  final String? username;
  final String? phoneNumber;
  final String? profileImage;
  final double? avgRating;
  final String? vehicleName;
  final int? ratingUserCount;
  final String? cancellationProbability;

  factory RideCreator.fromJson(Map<String, dynamic> json) {
    return RideCreator(
      username: json["username"],
      phoneNumber: json["phone_number"],
      profileImage: json["profile_image"],
      avgRating: json["avg_rating"],
      vehicleName: json["vehicle_name"],
      ratingUserCount: json["rating_user_count"],
      cancellationProbability: json["cancellation_probability"],
    );
  }
}

class RideDetails {
  RideDetails({
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.fromLocation,
    required this.toLocation,
    required this.distanceKm,
    required this.price,
    required this.totalPrice,
  });

  final Duration? duration;
  final String? startTime;
  final String? endTime;
  final String? fromLocation;
  final String? toLocation;
  final double? distanceKm;
  final double? price;
  final double? totalPrice;

  factory RideDetails.fromJson(Map<String, dynamic> json) {
    return RideDetails(
      duration: json["duration"] == null
          ? null
          : Duration.fromJson(json["duration"]),
      startTime: json["start_time"],
      endTime: json["end_time"],
      fromLocation: json["from_location"],
      toLocation: json["to_location"],
      distanceKm: json["distance_km"],
      price: json["price"],
      totalPrice: json["total_price"],
    );
  }
}

class Duration {
  Duration({required this.hours, required this.minutes, required this.display});

  final int? hours;
  final int? minutes;
  final String? display;

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      hours: json["hours"],
      minutes: json["minutes"],
      display: json["display"],
    );
  }
}

class OtherPassengers {
  final int? id;
  final String? profileImage;
  final String? name;
  OtherPassengers({
    required this.id,
    required this.profileImage,
    required this.name,
  });
  factory OtherPassengers.fromJson(Map<String, dynamic> json) {
    return OtherPassengers(
      id: json["id"],
      profileImage: json["profile_image"],
      name: json["name"],
    );
  }
}
