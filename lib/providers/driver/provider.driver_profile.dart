import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' hide MultipartFile, Response;
import 'package:velocyverse/models/model.driverDetails.dart';
import 'package:velocyverse/networking/apiservices.dart';

class DriverProfileProvider extends ChangeNotifier {
  DriverProfileProvider({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // xdw
  DriverDetailsModel? _driverDetails;
  DriverDetailsModel? get profileDetails => _driverDetails;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // EarningsNreportModel? rideDetails;

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

  Future<bool> getDriverProfile() async {
    try {
      final response = await _apiService.getRequest('/driver/driver-setting/');

      if (response.statusCode == 200) {
        final data = response.data;

        _driverDetails = DriverDetailsModel.fromJson(data['data']);
        notifyListeners();

        return true; // returning full Response object
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return false; // return null if not successful
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in todayEarnings: $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> updateDriverProfile({
    required String name,
    required String email,
    required String imagePath,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Prepare multipart form data
      final formData = FormData.fromMap({
        'username': name,
        'email': email,
        if (imagePath.isNotEmpty && !imagePath.startsWith('http'))
          'profile_image': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final response = await _apiService.putRequest(
        '/driver/driver-setting/', // Adjust if endpoint differs
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _driverDetails = DriverDetailsModel.fromJson(data['data']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in updateDriverProfile: $e');
      debugPrintStack(stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
