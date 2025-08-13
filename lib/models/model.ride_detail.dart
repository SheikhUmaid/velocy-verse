class RideDetail {
  bool? status;
  String? message;
  Data? data;

  RideDetail({this.status, this.message, this.data});

  RideDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['status'] = status;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    return jsonData;
  }
}

class Data {
  int? id;
  User? user;
  String? city;
  String? vehicleType;
  List<dynamic>? rideStops; // Changed from List<Null>
  String? createdAt;
  String? rideType;
  String? scheduledTime;
  String? fromLocation;
  String? fromLatitude;
  String? fromLongitude;
  String? toLocation;
  String? toLatitude;
  String? toLongitude;
  String? distanceKm;
  String? estimatedPrice;
  String? offeredPrice;
  String? status;
  bool? womenOnly;
  String? startTime;
  String? endTime;
  String? ridePurpose;
  bool? requireOtp;
  int? driver;
  dynamic company; // Kept as dynamic to allow flexibility
  List<dynamic>? employees; // Changed from List<Null>

  Data({
    this.id,
    this.user,
    this.city,
    this.vehicleType,
    this.rideStops,
    this.createdAt,
    this.rideType,
    this.scheduledTime,
    this.fromLocation,
    this.fromLatitude,
    this.fromLongitude,
    this.toLocation,
    this.toLatitude,
    this.toLongitude,
    this.distanceKm,
    this.estimatedPrice,
    this.offeredPrice,
    this.status,
    this.womenOnly,
    this.startTime,
    this.endTime,
    this.ridePurpose,
    this.requireOtp,
    this.driver,
    this.company,
    this.employees,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    city = json['city'];
    vehicleType = json['vehicle_type'];
    rideStops = json['ride_stops'] ?? [];
    createdAt = json['created_at'];
    rideType = json['ride_type'];
    scheduledTime = json['scheduled_time'];
    fromLocation = json['from_location'];
    fromLatitude = json['from_latitude'];
    fromLongitude = json['from_longitude'];
    toLocation = json['to_location'];
    toLatitude = json['to_latitude'];
    toLongitude = json['to_longitude'];
    distanceKm = json['distance_km'];
    estimatedPrice = json['estimated_price'];
    offeredPrice = json['offered_price'];
    status = json['status'];
    womenOnly = json['women_only'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    ridePurpose = json['ride_purpose'];
    requireOtp = json['require_otp'];
    driver = json['driver'];
    company = json['company'];
    employees = json['employees'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['id'] = id;
    if (user != null) {
      jsonData['user'] = user!.toJson();
    }
    jsonData['city'] = city;
    jsonData['vehicle_type'] = vehicleType;
    jsonData['ride_stops'] = rideStops ?? [];
    jsonData['created_at'] = createdAt;
    jsonData['ride_type'] = rideType;
    jsonData['scheduled_time'] = scheduledTime;
    jsonData['from_location'] = fromLocation;
    jsonData['from_latitude'] = fromLatitude;
    jsonData['from_longitude'] = fromLongitude;
    jsonData['to_location'] = toLocation;
    jsonData['to_latitude'] = toLatitude;
    jsonData['to_longitude'] = toLongitude;
    jsonData['distance_km'] = distanceKm;
    jsonData['estimated_price'] = estimatedPrice;
    jsonData['offered_price'] = offeredPrice;
    jsonData['status'] = status;
    jsonData['women_only'] = womenOnly;
    jsonData['start_time'] = startTime;
    jsonData['end_time'] = endTime;
    jsonData['ride_purpose'] = ridePurpose;
    jsonData['require_otp'] = requireOtp;
    jsonData['driver'] = driver;
    jsonData['company'] = company;
    jsonData['employees'] = employees ?? [];
    return jsonData;
  }
}

class User {
  int? id;
  String? phoneNumber;
  String? username;
  String? profile;

  User({this.id, this.phoneNumber, this.username, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phone_number'];
    username = json['username'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['id'] = id;
    jsonData['phone_number'] = phoneNumber;
    jsonData['username'] = username;
    jsonData['profile'] = profile;
    return jsonData;
  }
}
