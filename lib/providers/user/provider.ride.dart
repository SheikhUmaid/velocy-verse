import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/networking/apiservices.dart';

class RideProvider extends ChangeNotifier {
  RideProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  LocationModel? _fromLocation;
  LocationModel? _toLocation; //---> where it is a model of lat tn name address]
  String rideType = 'now';

  set fromLocation(LocationModel f) {
    _fromLocation = f;
    notifyListeners();
  }

  set toLocation(LocationModel f) {
    _toLocation = f;
    notifyListeners();
  }

  Future<Response> confirmRide() async {
    FlutterSecureStorage _storage = FlutterSecureStorage();
    try {
      final accessToken = await _storage.read(key: "access");
      final response = await _apiService.postRequest(
        "/rider/confirm_location/",
        data: {},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      rethrow;
    }
  }
}
