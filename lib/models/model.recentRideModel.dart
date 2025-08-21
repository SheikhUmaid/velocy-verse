class RecentrRideDetailsModel {
  RecentrRideDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final Data? data;

  factory RecentrRideDetailsModel.fromJson(Map<String, dynamic> json) {
    return RecentrRideDetailsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.rideId,
    required this.fromLocation,
    required this.toLocation,
    required this.stops,
    required this.startTime,
    required this.distanceKm,
    required this.creditedAmount,
    required this.paymentMethod,
    required this.duration,
    required this.rider,
  });

  final int? rideId;
  final Location? fromLocation;
  final Location? toLocation;
  final List<dynamic> stops;
  final String? startTime;
  final double? distanceKm;
  final double? creditedAmount;
  final String? paymentMethod;
  final String? duration;
  final Rider? rider;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rideId: json["ride_id"],
      fromLocation: json["from_location"] == null
          ? null
          : Location.fromJson(json["from_location"]),
      toLocation: json["to_location"] == null
          ? null
          : Location.fromJson(json["to_location"]),
      stops: json["stops"] == null
          ? []
          : List<dynamic>.from(json["stops"]!.map((x) => x)),
      startTime: json["start_time"],
      distanceKm: json["distance_km"],
      creditedAmount: json["credited_amount"],
      paymentMethod: json["payment_method"],
      duration: json["duration"],
      rider: json["rider"] == null ? null : Rider.fromJson(json["rider"]),
    );
  }
}

class Location {
  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String? address;
  final double? latitude;
  final double? longitude;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}

class Rider {
  Rider({
    required this.username,
    required this.profileImage,
    required this.ratingReview,
  });

  final String? username;
  final String? profileImage;
  final dynamic ratingReview;

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      username: json["username"],
      profileImage: json["profile_image"],
      ratingReview: json["rating_review"],
    );
  }
}
