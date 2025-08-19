import 'package:flutter/foundation.dart';
import 'package:velocyverse/models/model.earningsNreport.dart';
import 'package:velocyverse/models/model.recentRideModel.dart';
import 'package:velocyverse/models/model.recentRides.dart';
import 'package:velocyverse/networking/apiservices.dart';

class EaningsNreportsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  EarningsNreportModel? _earnings;
  EarningsNreportModel? get earnings => _earnings;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EarningsNreportModel? rideDetails;

  Future<bool> fetchEarningsNReport() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getRequest(
        "driver/driver-earnings/",
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        final data = response.data;
        _earnings = EarningsNreportModel.fromJson(data['data']);
        notifyListeners();

        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error fetching earnings: $e");
      return false;
    }
  }

  Future<bool> requestCashOut(double amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.postRequest(
        "driver/cash-out/",
        // headers: {'Authorization': 'Bearer $accessToken'},
        data: {'amount': amount},
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error requesting cashout: $e");
      return false;
    }
  }
}
import 'package:flutter/foundation.dart';
import 'package:velocyverse/models/model.earningsNreport.dart';
import 'package:velocyverse/models/model.recentRideModel.dart';
import 'package:velocyverse/models/model.recentRides.dart';
import 'package:velocyverse/networking/apiservices.dart';

class EaningsNreportsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  EarningsNreportModel? _earnings;
  EarningsNreportModel? get earnings => _earnings;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EarningsNreportModel? rideDetails;

  Future<bool> fetchEarningsNReport() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getRequest(
        "driver/driver-earnings/",
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        final data = response.data;
        _earnings = EarningsNreportModel.fromJson(data['data']);
        notifyListeners();

        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error fetching earnings: $e");
      return false;
    }
  }

  Future<bool> requestCashOut(int amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.postRequest(
        "driver/cash-out/",
        // headers: {'Authorization': 'Bearer $accessToken'},
        data: {'amount': amount},
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error requesting cashout: $e");
      return false;
    }
  }
}
