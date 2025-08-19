import 'package:flutter/material.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/find_sharing_rides_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/shared_ride_details_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/ride_share_api_service/ride_share_api_service.dart';

class RideShareProvider extends ChangeNotifier {
  final RideShareApiService _rideShareApiService;
  RideShareProvider(this._rideShareApiService);

  FindSharingRidesModel _findSharingRidesModel = FindSharingRidesModel(
    status: false,
    message: '',
    data: [],
  );
  FindSharingRidesModel get findSharingRidesModel => _findSharingRidesModel;

  SharedRideDetailsResponseModel? _sharedRideDetailsResponseModel;

  SharedRideDetailsResponseModel? get sharedRideDetailsResponseModel =>
      _sharedRideDetailsResponseModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAvailableRidesRequest(
    String fromLocation,
    String toLocation,
    DateTime date,
    int seats,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _findSharingRidesModel = await _rideShareApiService.fetchAvailableRides(
        fromLocation,
        toLocation,
        date,
        seats,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSharedRideDetailsRequest(int rideId, int segmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sharedRideDetailsResponseModel = await _rideShareApiService
          .fetchRideShareDetails(rideId, segmentId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
