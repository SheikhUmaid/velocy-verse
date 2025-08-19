class FindSharingRidesModel {
  FindSharingRidesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<AvailableRides> data;

  factory FindSharingRidesModel.fromJson(Map<String, dynamic> json) {
    return FindSharingRidesModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<AvailableRides>.from(
              json["data"]!.map((x) => AvailableRides.fromJson(x)),
            ),
    );
  }
}

class AvailableRides {
  AvailableRides({
    required this.rideId,
    required this.rideDate,
    required this.segmentFrom,
    required this.segmentTo,
    required this.segmentDistanceKm,
    required this.segmentPrice,
    required this.fromArrivalTime,
    required this.toArrivalTime,
    required this.userName,
    required this.userProfile,
    required this.userRole,
    required this.avgRating,
    required this.availableSeats,
    required this.joinedUsersCount,
    required this.joinedUsersProfiles,
    required this.segmentId,
  });

  final int? rideId;
  final DateTime? rideDate;
  final String? segmentFrom;
  final String? segmentTo;
  final String? segmentDistanceKm;
  final int? segmentPrice;
  final DateTime? fromArrivalTime;
  final DateTime? toArrivalTime;
  final String? userName;
  final String? userProfile;
  final String? userRole;
  final double? avgRating;
  final int? availableSeats;
  final int? joinedUsersCount;
  final List<JoinedUserProfile> joinedUsersProfiles;
  final int? segmentId;

  factory AvailableRides.fromJson(Map<String, dynamic> json) {
    DateTime? _parseTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty) return null;
      try {
        final parts = timeStr.split(':');
        if (parts.length == 3) {
          final now = DateTime.now();
          return DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (_) {}
      return null;
    }

    return AvailableRides(
      rideId: json["ride_id"],
      rideDate: DateTime.tryParse(json["ride_date"] ?? ""),
      segmentFrom: json["segment_from"],
      segmentTo: json["segment_to"],
      segmentDistanceKm: json["segment_distance_km"],
      segmentPrice: json["segment_price"],
      fromArrivalTime: _parseTime(json["from_arrival_time"]),
      toArrivalTime: _parseTime(json["to_arrival_time"]),
      userName: json["user_name"],
      userProfile: json["user_profile"],
      userRole: json["user_role"],
      avgRating: json["avg_rating"],
      availableSeats: json["available_seats"],
      joinedUsersCount: json["joined_users_count"],
      joinedUsersProfiles: json["joined_users_profiles"] == null
          ? []
          : List<JoinedUserProfile>.from(
              json["joined_users_profiles"]!.map((x) => x),
            ),
      segmentId: json["segment_id"],
    );
  }
}

class JoinedUserProfile {
  final int? id;
  final String? profileImage;
  final String? name;
  JoinedUserProfile({
    required this.id,
    required this.profileImage,
    required this.name,
  });

  factory JoinedUserProfile.fromJson(Map<String, dynamic> json) {
    return JoinedUserProfile(
      id: json["id"],
      profileImage: json["profile_image"],
      name: json["name"],
    );
  }
}
