import 'dart:math';
import 'package:flutter/material.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/networking/apiservices.dart';

class RideProvider extends ChangeNotifier {
  RideProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  LocationModel? _fromLocation;
  LocationModel? _toLocation; //---> where it is a model of lat tn name address]
  double? _distance;
  String rideType = 'now';
  double? _estimatedPrice;
  int? _id;
  LocationModel? get fromLocation => _fromLocation;
  LocationModel? get toLocation => _toLocation;
  double? get distance => _distance;
  double? get estimatedPrice => _estimatedPrice;

  set distance(double? d) {
    if (d != null) {
      // Round to 2 decimal places before storing
      final mod = pow(10.0, 2).toDouble();
      _distance = ((d * mod).round().toDouble() / mod);
    } else {
      _distance = null;
    }
    notifyListeners();
  }

  set fromLocation(LocationModel? f) {
    _fromLocation = f;
    notifyListeners();
  }

  set estimatedPrice(double? e) {
    _estimatedPrice = e;
    notifyListeners();
  }

  set toLocation(LocationModel? f) {
    _toLocation = f;
    notifyListeners();
  }

  Future<bool> confirmRide() async {
    try {
      final response = await _apiService.postRequest(
        "/rider/confirm_location/",
        data: {
          "ride_type": rideType,
          "city_name": "Bangalore",
          "from_location": _fromLocation!.address,
          "from_latitude": _fromLocation!.latitude,
          "from_longitude": _fromLocation!.longitude,
          "to_location": _toLocation!.address,
          "to_latitude": _toLocation!.latitude,
          "to_longitude": _toLocation!.longitude,
          "distance_km": _distance,
        },
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 201) {
        _id = response.data['id'];
        await getEstimatedPrice(vehicleId: 2);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> getEstimatedPrice({required int vehicleId}) async {
    try {
      final response = await _apiService.postRequest(
        "/rider/estimate-price/",
        data: {"ride_id": _id, 'vehicle_type_id': vehicleId},
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        estimatedPrice = response.data['data']['estimated_price'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> rideBooking({int? offeredPrice, required womenOnly}) async {
    try {
      final response = await _apiService.patchRequest(
        "/rider/ride-booking/$_id",
        data: {"women_only": womenOnly, "offered_price": offeredPrice},
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 201) {
        _id = response.data['id'];
        await getEstimatedPrice(vehicleId: 2);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return false;
    }
  }
}
