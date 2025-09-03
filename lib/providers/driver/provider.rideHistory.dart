import 'package:flutter/foundation.dart';
import 'package:VelocyTaxzz/models/model.recentRideModel.dart';
import 'package:VelocyTaxzz/models/model.recentRides.dart';
import 'package:VelocyTaxzz/networking/apiservices.dart';

class RecentRidesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  DriverRecentRidesModel? _rideHistory;
  DriverRecentRidesModel? get rideHistory => _rideHistory;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RecentrRideDetailsModel? rideDetails;

  Future<bool> fetchRideHistory() async {
    _isLoading = true;
    try {
      final response = await _apiService.getRequest(
        "driver/driver-ride-history/",
        // headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        final data = response.data;
        _rideHistory = DriverRecentRidesModel.fromJson(data);
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
      debugPrint("Error fetching ride history: $e");
      return false;
    }
  }

  Future<void> fetchRideDetails(String rideId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getRequest(
        '/driver/ride-history-details/$rideId',
      );
      rideDetails = RecentrRideDetailsModel.fromJson(response.data);
    } catch (e) {
      debugPrint("Error fetching ride details: $e");
      rideDetails = null;
    }
    _isLoading = false;
    notifyListeners();
  }
}
