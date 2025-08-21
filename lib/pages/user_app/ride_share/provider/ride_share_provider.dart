import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/find_sharing_rides_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/my_rides_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/my_vehicles_model.dart';
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

  MyRidesResponseModel _myRidesResponseModel = MyRidesResponseModel(
    status: false,
    message: '',
    data: [],
  );
  MyRidesResponseModel get myRidesResponseModel => _myRidesResponseModel;

  MyVehiclesResponseModel _myVehiclesResponseModel = MyVehiclesResponseModel(
    status: false,
    message: '',
    data: [],
  );
  MyVehiclesResponseModel get myVehiclesResponseModel =>
      _myVehiclesResponseModel;

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

  Future<void> fetchMyRides() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _myRidesResponseModel = await _rideShareApiService.fetchMyRidesRequest();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _myVehiclesResponseModel = await _rideShareApiService
          .fetchMyVehiclesRequest();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicleRequest({
    required String vehicleNumber,
    required String modelName,
    required int seatCapacity,
    required File aadharCard,
    required File drivingLicense,
    required File registrationDoc,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _rideShareApiService.addVehiclesForRideSharing(
        vehicleNumber: vehicleNumber,
        modelName: modelName,
        seatCapacity: seatCapacity,
        aadharCard: aadharCard,
        drivingLicense: drivingLicense,
        registrationDoc: registrationDoc,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
