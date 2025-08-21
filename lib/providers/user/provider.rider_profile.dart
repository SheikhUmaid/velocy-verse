// providers/user/provider.rider_profile.dart
import 'package:flutter/material.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:dio/dio.dart';

class RiderProfileProvider extends ChangeNotifier {
  RiderProfileProvider({required ApiService apiService})
    : _apiService = apiService;
  final ApiService _apiService;

  String _name = " ... ";
  String _contactNumber = "__";
  String _email = "__";
  String? _profileURL;
  bool _isLoading = false;

  String get name => _name;
  String get contactNumber => _contactNumber;
  String get email => _email;
  String? get profileURL => _profileURL;
  bool get isLoading => _isLoading;

  Future<bool> getRiderProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getRequest("/rider/rider-profile/");

      if (response.statusCode == 200) {
        _name = response.data['username'];
        _email = response.data['email'] ?? 'email not set';
        _contactNumber = response.data['phone_number'];
        _profileURL = response.data["profile"];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Exception in getRiderProfile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> updateRiderProfile({
  //   required String name,
  //   required String email,
  //   required String imagePath,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     final formData = FormData.fromMap({
  //       'name': name,
  //       'email': email,
  //       if (imagePath.isNotEmpty)
  //         'image': await MultipartFile.fromFile(
  //           imagePath,
  //           filename: imagePath.split('/').last,
  //         ),
  //     });

  //     final response = await _apiService.putRequest(
  //       '/rider/rider-profile/',
  //       data: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //       _name = data['username'];
  //       _email = data['email'] ?? 'email not set';
  //       _profileURL = data['profile'];
  //       return true;
  //     } else {
  //       debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint('Exception in updateRiderProfile: $e');
  //     debugPrintStack(stackTrace: stackTrace);
  //     return false;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<bool> updateRiderProfile({
    required String name,
    required String email,
    required String imagePath,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
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
        'rider/rider-profile/',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _name = data['username'];
        _email = data['email'] ?? 'email not set';
        _profileURL = data['profile'];
        return true;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Exception in updateRiderProfile: $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
