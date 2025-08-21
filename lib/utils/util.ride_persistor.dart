import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

class RidePersistor {
  static const String _rideKey = "activeRide";

  /// Save current ride state into SharedPreferences
  static Future<void> save(RideProvider provider) async {
    final prefs = await SharedPreferences.getInstance();

    final map = {
      "id": provider.activeId,
      "fromLocation": provider.fromLocation?.toJson(),
      "toLocation": provider.toLocation?.toJson(),
      "distance": provider.distance,
      "estimatedPrice": provider.estimatedPrice,
      "otp": provider.otp,
      "rideCompleted": provider.rideCompleted,
      "rideType": provider.rideType,
    };

    await prefs.setString(_rideKey, jsonEncode(map));
  }

  /// Load ride state from SharedPreferences into provider
  static Future<void> load(RideProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_rideKey);

    if (json != null) {
      final map = jsonDecode(json);

      provider.id = map["id"];
      provider.fromLocation = map["fromLocation"] != null
          ? LocationModel.fromJson(map["fromLocation"])
          : null;
      provider.toLocation = map["toLocation"] != null
          ? LocationModel.fromJson(map["toLocation"])
          : null;
      provider.distance = (map["distance"] as num?)?.toDouble();
      provider.estimatedPrice = (map["estimatedPrice"] as num?)?.toDouble();
      provider.otp = map["otp"];
      // provider.rideCompleted = map["rideCompleted"] ?? false;
      provider.rideType = map["rideType"];
    }
  }

  /// Clear ride state from SharedPreferences + provider
  static Future<void> clear(RideProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rideKey);

    provider.id = null;
    provider.fromLocation = null;
    provider.toLocation = null;
    provider.distance = null;
    provider.estimatedPrice = null;
    provider.otp = null;
    // provider.rideCompleted = false;
  }
}
