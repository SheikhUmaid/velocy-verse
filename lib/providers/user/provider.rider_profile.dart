import 'package:flutter/material.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:dio/dio.dart';

class RiderProfileProvider extends ChangeNotifier {
  RiderProfileProvider({required ApiService apiService})
    : _apiService = apiService;
  final ApiService _apiService;

  String name = " ... ";
  String contactNumber = "__";
  String email = "__";
  String? profileURL;
  bool isLoading = false;

  Future<bool> getRiderProfile() async {
    try {
      final response = await _apiService.getRequest("/rider/rider-profile/");

      if (response.statusCode == 200) {
        name = response.data['username'];
        email = response.data['email'] ?? 'email not set';
        contactNumber = response.data['phone_number'];
        profileURL = response.data["profile"];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      return false;
    }
  }

  Future<bool> updateRiderProfile({
    required String name,
    required String email,
    required String imagePath,
  }) async {
    try {
      // Prepare multipart form data
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        if (imagePath.isNotEmpty)
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final response = await _apiService.putRequest(
        'rider/rider-profile/', // Adjust if endpoint differs
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        notifyListeners();
        return true;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in updateDriverProfile: $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
