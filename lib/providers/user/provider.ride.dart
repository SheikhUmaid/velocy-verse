import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RideProvider extends ChangeNotifier {
  RideProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  LocationModel? _fromLocation;
  LocationModel? _toLocation; //---> where it is a model of lat tn name address]
  double? _distance;
  String rideType = 'now';
  double? _estimatedPrice;
  int? _id;
  LocationModel? get fromLocation => _fromLocation;
  LocationModel? get toLocation => _toLocation;
  double? get distance => _distance;
  double? get estimatedPrice => _estimatedPrice;

  WebSocketChannel? _channel;

  String? _otp;
  String? get otp => _otp;

  void Function(String otp)? onOtpReceived;
  void Function()? onOtpVerified;
  bool _rideCompleted = false;
  bool get rideCompleted => _rideCompleted;

  VoidCallback? onRideCompleted; // ✅ callback property
  set distance(double? d) {
    if (d != null) {
      // Round to 2 decimal places before storing
      final mod = pow(10.0, 2).toDouble();
      _distance = ((d * mod).round().toDouble() / mod);
    } else {
      _distance = null;
    }
    notifyListeners();
  }

  set fromLocation(LocationModel? f) {
    _fromLocation = f;
    notifyListeners();
  }

  set estimatedPrice(double? e) {
    _estimatedPrice = e;
    notifyListeners();
  }

  set toLocation(LocationModel? f) {
    _toLocation = f;
    notifyListeners();
  }

  Future<bool> confirmRide({
    // String? scheduleDateTime,
    DateTime? scheduledTime,
  }) async {
    try {
      final response = await _apiService.postRequest(
        "/rider/confirm_location/",
        data: {
          "ride_type": rideType,
          "city_name": "Bangalore",
          "from_location": _fromLocation!.address,
          "from_latitude": _fromLocation!.latitude,
          "from_longitude": _fromLocation!.longitude,
          "to_location": _toLocation!.address,
          "to_latitude": _toLocation!.latitude,
          "to_longitude": _toLocation!.longitude,
          "distance_km": _distance,
          "scheduled_time": DateFormat(
            "yyyy-MM-dd'T'HH:mm",
          ).format(scheduledTime ?? DateTime(1234, 1, 1, 0, 0)),
        },
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 201) {
        _id = response.data['id'];
        await getEstimatedPrice(vehicleId: 2);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      rethrow;
      // return false;
    }
  }

  Future<bool> getEstimatedPrice({required int vehicleId}) async {
    try {
      final response = await _apiService.postRequest(
        "/rider/estimate-price/",
        data: {"ride_id": _id, 'vehicle_type_id': vehicleId},
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        estimatedPrice = response.data['data']['estimated_price'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> ridePatchBooking({
    String? offeredPrice,
    required womenOnly,
  }) async {
    try {
      final response = await _apiService.patchRequest(
        "/rider/ride-booking/$_id/",
        data: {
          "women_only": womenOnly,
          "offered_price": offeredPrice,
          'status': 'pending',
        },
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        // _id = response.data['id'];
        // await getEstimatedPrice(vehicleId: 2);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
      // debugPrint(e.toString());
      // return false;
    }
  }

  Future<Response?> driverArrivedScreen() async {
    try {
      final response = await _apiService.getRequest(
        "/rider/driver-arrived-screen/$_id/",
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return null;
    }
  }

  // Call this when starting ride waiting
  void connectToOtpWs(int rideId) {
    // Example WebSocket URL: adjust to your backend endpoint
    //ws://82.25.104.152:9000/ws/rider/otp/
    final wsUrl = Uri.parse("ws://82.25.104.152:9000/ws/rider/otp/$_id/");
    debugPrint(wsUrl.toString());
    _channel = WebSocketChannel.connect(wsUrl);
    debugPrint(
      "----------------------------Connected to ws ===========================",
    );
    _channel!.stream.listen(
      (message) {
        debugPrint("Received WS message: $message");
        try {
          final data = jsonDecode(message);

          debugPrint(data.toString());

          if (data['type'] == 'otp') {
            _otp = data['otp'];
            notifyListeners();
            if (onOtpReceived != null) {
              onOtpReceived!(_otp!);
            }
          }

          if (data['type'] == 'otp_verified') {
            // _otp = data['otp'];
            notifyListeners();
            if (onOtpVerified != null) {}
          }
        } catch (e) {
          debugPrint("Error decoding WS message: $e");
        }
      },
      onError: (error) {
        debugPrint("WebSocket error: $error");
      },
      onDone: () {
        debugPrint("WebSocket closed");
        onOtpVerified!();
      },
    );
  }

  void connectRideWebSocket(int rideId) {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://82.25.104.152:9000/ws/rider/otp/$_id/'),
    );

    channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        debugPrint("WS Data: $data");

        switch (data['type']) {
          case 'otp':
            print("📩 OTP Received: ${data['otp']}");
            break;

          case 'ride_completed':
            print("✅ Ride Completed: ${data['message']}");
            _rideCompleted = true;
            notifyListeners(); // UI updates
            break;

          default:
            print("Unknown message type: $data");
        }
      },
      onError: (error) {
        print("⚠️ WebSocket Error: $error");
      },
      onDone: () {
        print("❌ WebSocket Closed");
        // 🔹 Trigger callback if set
        if (onRideCompleted != null) {
          onRideCompleted!();
        }
      },
    );
  }

  Future<bool> finalizePayment() async {
    try {
      final response = await _apiService.postRequest(
        "rider/finalize-payment/",
        data: {
          "ride_id": _id,
          "payment_method": "upi",
          "tip_amount": 9,
          "upi_payment_id": "111",
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // rethrow;
      debugPrint(e.toString());
      return false;
    }
  }

  void disconnectWs() {
    _channel?.sink.close();
    _channel = null;
  }
}
