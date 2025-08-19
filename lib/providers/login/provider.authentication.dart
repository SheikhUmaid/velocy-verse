import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/services/secure_storage_service.dart';
import 'package:velocyverse/utils/util.get_file_extension.dart';

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

  Future<bool> loginWithOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      FlutterSecureStorage secureStorage = FlutterSecureStorage();
      final response = await _apiService.postRequest(
        '/auth_api/otp-login/',
        data: {'phone_number': phoneNumber, 'otp': otp},
        doesNotRequireAuthHeader: true,
      );

      if (response.statusCode == 200) {
        await secureStorage.write(
          key: 'role',
          value: response.data['user']['role'],
        );

        await SecureStorage.saveTokens(
          accessToken: response.data['access'],
          refreshToken: response.data['refresh'],
        );
        debugPrint("Tokens stored successfully");
        return true;
      } else {
        debugPrint("OTP verification failed: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Login OTP error: $e");
      return false;
    }
  }

  Future<bool> loginWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _apiService.postRequest(
        '/auth_api/password-login/',
        data: {'phone_number': phoneNumber, 'password': password},
        doesNotRequireAuthHeader: true,
      );

      if (response.statusCode == 200) {
        FlutterSecureStorage secureStorage = FlutterSecureStorage();
        await secureStorage.write(
          key: 'role',
          value: response.data['user']['role'],
        );
        await SecureStorage.saveTokens(
          accessToken: response.data['access'],
          refreshToken: response.data['refresh'],
        );
        debugPrint("Tokens stored successfully");
        return true;
      } else {
        debugPrint("Password login failed: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Login password error: $e");
      return false;
    }
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
        doesNotRequireAuthHeader: true,
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
        doesNotRequireAuthHeader: true,
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

  Future<bool> sendOtp({required String mode}) async {
    try {
      final response = await _apiService.postRequest(
        'auth_api/send-otp/?mode=$mode',
        data: {'phone_number': _phoneNumber},
        doesNotRequireAuthHeader: true,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false; // Or return false if you don’t want to throw
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      final response = await _apiService.postRequest(
        '/verify-otp/',
        data: {'phone_number': _phoneNumber, 'otp': otp},
        doesNotRequireAuthHeader: true,
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

  Future<bool> becomeADriver() async {
    try {
      final response = await _apiService.postRequest(
        'auth_api/become-driver/',
        data: {'user_id': _registeredUser},
        doesNotRequireAuthHeader: true,
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow; // Or return false if you don’t want to throw
    }
  }

  Future<bool> driverRegisteration({
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleCompany,
    required String vehicleModel,
    required String passingYear,
  }) async {
    try {
      await becomeADriver();
      final response = await _apiService.postRequest(
        'auth_api/driver-registration/',
        data: {
          'vehicle_number': vehicleNumber,
          'vehicle_type': vehicleType,
          'year': int.parse(passingYear), // Match form-data string format
          'car_company': vehicleCompany,
          'car_model': vehicleModel,
          'user_id':
              _registeredUser, // Assuming _registeredUser is set elsewhere
        },
        doesNotRequireAuthHeader: true, // Skips token
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Driver registration failed: $e');
      return false;
    }
  }

  Future<bool> documentUpload({
    required String licensePlateNumber,
    required String vehicleType,
    required File? vehicleRegistrationDoc,
    required File? driverLicense,
    required File? vehicleInsurance,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'license_plate_number': licensePlateNumber,
        'vehicle_type': vehicleType,
        'user_id': _registeredUser,
        if (vehicleRegistrationDoc != null)
          'vehicle_registration_doc': await MultipartFile.fromFile(
            vehicleRegistrationDoc.path,
            filename:
                'vehicle_registration.${getFileExtension(vehicleRegistrationDoc.path)}',
          ),
        if (driverLicense != null)
          'driver_license': await MultipartFile.fromFile(
            driverLicense.path,
            filename: 'driver_license.${getFileExtension(driverLicense.path)}',
          ),
        if (vehicleInsurance != null)
          'vehicle_insurance': await MultipartFile.fromFile(
            vehicleInsurance.path,
            filename:
                'vehicle_insurance.${getFileExtension(vehicleInsurance.path)}',
          ),
      });

      final response = await _apiService.postRequest(
        '/auth_api/document-upload/',
        data: formData,
        headers: {'Content-Type': 'multipart/form-data'},
        doesNotRequireAuthHeader: true,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Document upload error: $e');
      return false;
    }
  }
}
