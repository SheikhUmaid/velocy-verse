import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocyverse/networking/apiservices.dart';

class Authentication extends ChangeNotifier {
  final ApiService _apiService;
  String _phoneNumber = '';

  Authentication({required ApiService apiService}) : _apiService = apiService;

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void clearPhoneNumber() {
    _phoneNumber = '';
    notifyListeners();
  }

  Future<bool> sendOtp() async {
    try {
      final response = await _apiService.postRequest(
        'send-otp/',
        data: {'phone_number': _phoneNumber},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow; // Or return false if you don’t want to throw
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      final response = await _apiService.postRequest(
        '/verify-otp/',
        data: {'phone_number': _phoneNumber, 'otp': otp},
      );
      if (response.statusCode == 201) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        // Store the token securely
        await storage.write(
          key: "access_token",
          value: response.data["access_token"],
        );
        await storage.write(
          key: "refresh_token",
          value: response.data["refresh_token"],
        );
        return true;
      } else {
        // Handle the case where OTP verification fails
        ("OTP verification failed: ${response.data}");
        return false;
      }
      // return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }
}
