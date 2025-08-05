import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocyverse/networking/apiservices.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  int? _registeredUser;

  set registeredUser(int value) {
    _registeredUser = value;
    notifyListeners();
  }

  void clearRegsteredUser() {
    _registeredUser = null;
    notifyListeners();
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void clearPhoneNumber() {
    _phoneNumber = '';
    notifyListeners();
  }

  Future<bool> profileSetup({
    required String username,
    required String gender,
    required String street,
    required String area,
    required String addressType,
    File? profile,
    File? aadhar,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'username': username,
        'gender': gender,
        'street': street,
        'area': area,
        'address_type': addressType,
        'user_id': _registeredUser,
        if (profile != null)
          'profile': await MultipartFile.fromFile(
            profile.path,
            filename: 'profile.jpg',
          ),
        if (aadhar != null)
          'aadhar_card': await MultipartFile.fromFile(
            aadhar.path,
            filename: 'aadhar.jpg',
          ),
      });
      final response = await _apiService.putRequest(
        '/auth_api/profile-setup/',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerRequest({
    required String phoneNumber,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.postRequest(
        '/auth_api/register/',
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
      if (response.statusCode == 201) {
        debugPrint(response.data['user_id'].toString());
        _registeredUser = int.parse(response.data['user_id'].toString());
        return true;
      } else {
        // Handle the case where OTP verification fails
        ("OTP verification failed: ${response.data}");
        return false;
      }
      // return response.statusCode == 201;
    } catch (e) {
      // rethrow;
      return false;
    }
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
