import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:VelocyTaxzz/models/driver/model.ongoingRide.dart';
import 'package:VelocyTaxzz/models/model.ride_detail.dart' hide Data;
import 'package:VelocyTaxzz/models/model.ride_request.dart';
import 'package:VelocyTaxzz/networking/apiservices.dart';
import 'package:VelocyTaxzz/services/secure_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverProvider extends ChangeNotifier {
  DriverProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool? _onlineStatus;
  List<Data> nowRides = [];
  bool? get onlineStatus => _onlineStatus;
  int? activeRide;
  RideDetail? rideDetail;
  VoidCallback? paymentSuccess;
  VoidCallback? paymentFailed;

  OngoingRide_Model? ongoingRide;

  void driverINIT() async {
    _onlineStatus = await _secureStorage.read(key: "is_online") == "true";
    await getNowRides();
    await getOngoingRides();
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

  void connectPaymentWebSocket() async {
    final token = await SecureStorage.getAccessToken();
    final uri = Uri.parse(
      'ws://82.25.104.152:9000/ws/payment/status/normal/$activeRide/?token=$token',
    );
    final wsChannel = WebSocketChannel.connect(uri);

    wsChannel.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        final type = decoded['type'];
        final paymentStatus = decoded['payment_status'];
        final message = decoded['message'];

        if (type == 'payment_status_update') {
          if (paymentStatus == 'completed') {
            // _showSuccess(message);
            paymentSuccess!();
          }
          if (paymentStatus == 'failed') {
            // _showSuccess(message);
            paymentFailed!();
          }
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket closed');
      },
    );
  }

  Future<bool> getOngoingRides() async {
    try {
      final response = await _apiService.getRequest(
        '/driver/driver-active-rides/',
      );

      if (response.statusCode == 200) {
        // print('active ride response = ${response.data}');
        final activeRideReq = OngoingRide_Model.fromJson(response.data[1]);
        // print(activeRideReq.status);
        // print(activeRideReq);
        ongoingRide = activeRideReq;
        notifyListeners();
        return true;
        // if (activeRideReq == true && activeRideReq != null) {

        //   // for (var ride in activeRideReq) {
        //   //   nowRides.add(ride);

        //   // }
        //   return true;
        // }
      }
      return false;
    } catch (e) {
      print("Error in getNowRides: $e");
      return false;
    }
  }
}
