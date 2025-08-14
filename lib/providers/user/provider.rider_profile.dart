import 'package:flutter/material.dart';
import 'package:velocyverse/networking/apiservices.dart';

class RiderProfileProvider extends ChangeNotifier {
  RiderProfileProvider({required ApiService apiService})
    : _apiService = apiService;
  final ApiService _apiService;

  String name = " ... ";
  String? profileURL;

  Future<bool> getRiderProfile() async {
    try {
      final response = await _apiService.getRequest("/rider/rider-profile/");

      if (response.statusCode == 200) {
        name = response.data['username'];
        profileURL = response.data["profile"];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
