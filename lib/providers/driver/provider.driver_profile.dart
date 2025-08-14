import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:velocyverse/networking/apiservices.dart';

class DriverProfileProvider extends ChangeNotifier {
  DriverProfileProvider({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  void driverProfileINIT() async {}
  Future<Response?> todayEarnings() async {
    try {
      final response = await _apiService.getRequest('/driver/today-earnings/');

      if (response.statusCode == 200) {
        return response.data; // returning full Response object
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return null; // return null if not successful
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in todayEarnings: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<Response?> getDriverProfile() async {
    try {
      final response = await _apiService.getRequest('/driver/today-setting/');

      if (response.statusCode == 200) {
        return response.data; // returning full Response object
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return null; // return null if not successful
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in todayEarnings: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }
}
