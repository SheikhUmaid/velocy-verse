import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
<<<<<<< Updated upstream
import 'package:velocyverse/app.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/networking/notification_services.dart';
import 'package:velocyverse/services/secure_storage_service.dart';
import 'package:velocyverse/utils/util.get_file_extension.dart';
=======
import 'package:VelocyTaxzz/networking/apiservices.dart';
import 'package:VelocyTaxzz/networking/notification_services.dart';
import 'package:VelocyTaxzz/services/secure_storage_service.dart';
import 'package:VelocyTaxzz/utils/util.get_file_extension.dart';
>>>>>>> Stashed changes

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
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

  Future loginWithOTP({
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

  Future<Object> loginWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('ph no =>> $phoneNumber');
      print(password);
      final response = await _apiService.postRequest(
        '/auth_api/password-login/',
        data: {'phone_number': '+91' + phoneNumber, 'password': password},
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
        return response.data['user']['role'] == 'user' ? 'user' : 'driver';
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
      final formData = FormData.fromMap({
        'license_plate_number': licensePlateNumber,
        'vehicle_type': vehicleType,
        'user_id': _registeredUser!.toInt(),
        if (vehicleRegistrationDoc != null)
          'vehicle_registration_doc': await MultipartFile.fromFile(
            vehicleRegistrationDoc.path,
            filename:
                'vehicle_registration${getFileExtension(vehicleRegistrationDoc.path)}',
          ),
        if (driverLicense != null)
          'driver_license': await MultipartFile.fromFile(
            driverLicense.path,
            filename: 'driver_license${getFileExtension(driverLicense.path)}',
          ),
        if (vehicleInsurance != null)
          'vehicle_insurance': await MultipartFile.fromFile(
            vehicleInsurance.path,
            filename:
                'vehicle_insurance${getFileExtension(vehicleInsurance.path)}',
          ),
      });

      // Debugging: check what’s being sent
      print('Uploading fields: ${formData.fields}');
      formData.files.forEach((file) {
        print('Uploading file: ${file.key} -> ${file.value.filename}');
      });

      final response = await _apiService.postRequest(
        '/auth_api/document-upload/',
        data: formData,
        doesNotRequireAuthHeader: true,
        // ❌ don’t set Content-Type manually, Dio will add correct multipart boundary
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e, stack) {
      print('Document upload errorrrrrrrrrrrrrrrrrrrr: $e');
      print(stack);
      return false;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String VerificationID = '';
  String? _resendToken;
  set verificationId(String value) {
    VerificationID = value;
    notifyListeners();
  }

  // Future<bool> fb_sendOTP(String phNo) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   final completer =
  //       Completer<bool>(); // 👈 wait until OTP send status is known

  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: "+91$phNo",
  //       timeout: const Duration(seconds: 60),

  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         try {
  //           await _auth.signInWithCredential(credential);
  //           debugPrint("✅ Auto verification completed");
  //         } catch (e) {
  //           debugPrint("❌ Auto sign-in failed: $e");
  //         }
  //         _isLoading = false;
  //         notifyListeners();
  //       },

  //       verificationFailed: (FirebaseAuthException e) {
  //         debugPrint("❌ Verification failed: ${e.message}");
  //         _isLoading = false;
  //         notifyListeners();
  //         if (!completer.isCompleted) completer.complete(false); // ❌ failed
  //       },

  //       codeSent: (String verId, int? newResendToken) {
  //         VerificationID = verId;
  //         _resendToken = _resendToken;
  //         debugPrint("📩 OTP code sent");
  //         _isLoading = false;
  //         notifyListeners();
  //         if (!completer.isCompleted) completer.complete(true); // ✅ success
  //       },

  //       codeAutoRetrievalTimeout: (String verId) {
  //         VerificationID = verId;
  //         debugPrint("⌛ Auto-retrieval timeout");
  //         _isLoading = false;
  //         notifyListeners();
  //       },

  //       // forceResendingToken: _resendToken,
  //     );

  //     return completer.future; // 👈 wait here
  //   } catch (e) {
  //     debugPrint("❌ Error in fb_sendOTP: $e");
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // ?
  Future<bool> fb_sendOTP(String phNo, {bool forceResend = false}) async {
    _isLoading = true;
    notifyListeners();

    final completer = Completer<bool>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phNo',
        timeout: const Duration(seconds: 60),

        // forceResendingToken: forceResend ? _resendToken : null,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            // If auto-retrieval succeeds, this signs in without manual code entry
            await _auth.signInWithCredential(credential);
            debugPrint('✅ Auto verification completed');
          } catch (e) {
            debugPrint('❌ Auto sign-in failed: $e');
          } finally {
            _isLoading = false;
            notifyListeners();
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          debugPrint('❌ Verification failed: ${e.code} ${e.message}');
          _isLoading = false;
          notifyListeners();
          if (!completer.isCompleted) completer.complete(false);
        },

        codeSent: (String verId, int? newResendToken) {
          VerificationID = verId;
          _resendToken = newResendToken.toString();
          debugPrint('📩 OTP code sent. resendToken=$_resendToken');
          _isLoading = false;
          notifyListeners();
          if (!completer.isCompleted) completer.complete(true);
        },

        codeAutoRetrievalTimeout: (String verId) {
          VerificationID = verId;
          debugPrint('⌛ Auto-retrieval timeout');
          _isLoading = false;
          notifyListeners();
          // no completer here; code may still arrive manually
        },
      );

      return await completer.future;
    } catch (e) {
      debugPrint('❌ Error in fb_sendOTP: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  // ?==========

  // Future<Object?> fb_verifyOTP(String otp, bool isLogin) async {
  //   debugPrint("🔑 Verifying OTP: $otp");
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     if (VerificationID == null) {
  //       throw Exception("VerificationId is null. Please request OTP again.");
  //     }

  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: VerificationID!,
  //       smsCode: otp,
  //     );

  //     final userCredential = await _auth.signInWithCredential(credential);
  //     final user = userCredential.user;

  //     if (user != null) {
  //       final idToken = await user.getIdToken();
  //       debugPrint("🎟 Firebase Token: $idToken");

  //       if (isLogin) {
  //         final credsSent = await sendTokenToBackend(idToken!);
  //         if (credsSent == 'rider' || credsSent == 'driver') {
  //           _isLoading = false;
  //           notifyListeners();
  //           return credsSent;
  //         }
  //       } else {
  //         _isLoading = false;
  //         notifyListeners();
  //         return "success";
  //       }
  //     }

  //     _isLoading = false;
  //     notifyListeners();
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     debugPrint("❌ FirebaseAuthException: ${e.message}");
  //     _isLoading = false;
  //     notifyListeners();
  //     return null;
  //   } catch (e) {
  //     debugPrint("❌ Error verifying OTP: $e");
  //     _isLoading = false;
  //     notifyListeners();
  //     return null;
  //   }
  // }

  // ?
  Future<Object?> fb_verifyOTP(String otp, bool isLogin) async {
    debugPrint('🔑 Verifying OTP: $otp');
    _isLoading = true;
    notifyListeners();

    try {
      if (VerificationID == null || VerificationID!.isEmpty) {
        throw Exception('Missing verificationId. Please request OTP again.');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: VerificationID!,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        debugPrint('🎟 Firebase ID token received');

        if (isLogin) {
          final role = await sendTokenToBackend(idToken!);
          _isLoading = false;
          notifyListeners();
          return (role == 'rider' || role == 'driver') ? role : null;
        } else {
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ FirebaseAuthException: ${e.code} ${e.message}');
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('❌ Error verifying OTP: $e');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // ?===========
  Future<String?> sendTokenToBackend(String idToken) async {
    try {
      final response = await _apiService.postRequest(
        "/auth_api/firebase-auth/",
        headers: {"Content-Type": "application/json"},
        data: {
          "idToken": idToken,
          "d_token": NotificationService().fcmToken ?? "",
        },
      );

      print('Status code from backend: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final role = response.data['role'] as String?;
        final accessToken = response.data['access'] as String?;
        final refreshToken = response.data['refresh'] as String?;

        if (role != null && (role == "rider" || role == "driver")) {
          final secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'role', value: role);

          await SecureStorage.saveTokens(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
          );

          print('Role received = $role');
          return role;
        } else {
          print("Invalid role or missing tokens from backend");
          return null;
        }
      } else {
        print("Backend rejected token. Status: ${response.statusCode}");
        return null;
      }
    } catch (e, stack) {
      print("Error in sendTokenToBackend: $e");
      print(stack);
      return null;
    }
  }
}
