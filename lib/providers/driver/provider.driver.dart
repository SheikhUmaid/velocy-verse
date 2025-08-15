import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocyverse/models/model.ride_detail.dart' hide Data;
import 'package:velocyverse/models/model.ride_request.dart';
import 'package:velocyverse/networking/apiservices.dart';

class DriverProvider extends ChangeNotifier {
  DriverProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool? _onlineStatus;
  List<Data> nowRides = [];
  bool? get onlineStatus => _onlineStatus;
  int? activeRide;
  RideDetail? rideDetail;

  void driverINIT() async {
    _onlineStatus = await _secureStorage.read(key: "is_online") == "true";
    await getNowRides();
  }

  Future<bool> toggleOnlineStatus() async {
    try {
      final response = await _apiService.postRequest("/driver/toggle-online/");
      if (response.statusCode == 200) {
        _onlineStatus = response.data['data']['is_online'];
        notifyListeners();
      }
      return response.data['success'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> getNowRides() async {
    try {
      final response = await _apiService.postRequest(
        '/driver/available-now-rides/',
        data: {'city_name': "Bangalore"},
      );

      if (response.statusCode == 200) {
        final rideRequest = RideRequest.fromJson(response.data);
        nowRides.clear();
        if (rideRequest.status == true && rideRequest.data != null) {
          for (var ride in rideRequest.data!) {
            nowRides.add(ride);
            notifyListeners();
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error in getNowRides: $e");
      return false;
    }
  }

  Future<bool> getRideDetails() async {
    try {
      final response = await _apiService.getRequest(
        '/driver/ride-details/$activeRide',
      );

      if (response.statusCode == 200) {
        final data = response
            .data; // Assuming _apiService returns a Dio or HTTP response
        rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }

  Future<bool> acceptRide() async {
    try {
      final response = await _apiService.postRequest(
        '/driver/accept-ride/$activeRide/',
      );

      if (response.statusCode == 200) {
        final data = response
            .data; // Assuming _apiService returns a Dio or HTTP response
        // rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }

  Future<bool> beginRide() async {
    try {
      final response = await _apiService.postRequest(
        '/driver/begin-ride/$activeRide/',
      );

      if (response.statusCode == 200) {
        // final data = response
        // .data; // Assuming _apiService returns a Dio or HTTP response
        // rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }

  Future<bool> generateOTP() async {
    try {
      final response = await _apiService.postRequest(
        '/driver/generate-otp/$activeRide/',
      );

      if (response.statusCode == 200) {
        // final data = response
        // .data; // Assuming _apiService returns a Dio or HTTP response
        // rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }

  Future<bool> verifyOTP({required otp}) async {
    try {
      final response = await _apiService.postRequest(
        '/driver/verify-otp/$activeRide/',
        data: {"otp": otp},
      );

      if (response.statusCode == 200) {
        // final data = response
        // .data; // Assuming _apiService returns a Dio or HTTP response
        // rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }

  Future<bool> rideComplete({required otp}) async {
    try {
      final response = await _apiService.postRequest(
        // '/driver/verify-otp/$activeRide/',
        '/driver/complete-ride/$activeRide/',
        // data: {"otp": otp},
      );

      if (response.statusCode == 200) {
        debugPrint(
          "OSFGOFSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        );
        // final data = response
        // .data; // Assuming _apiService returns a Dio or HTTP response
        // rideDetail = RideDetail.fromJson(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      return false;
    }
  }
}
