import 'package:flutter/material.dart';
import 'package:velocyverse/pages/user_app/rental/data/rental_model.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';

class RentalProvider extends ChangeNotifier {
  final RentalApiService _rentalApiService;

  RentalProvider(this._rentalApiService);

  List<RentalModel> _vehicles = [];
  List<RentalModel> get vehicles => _vehicles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vehicles = await _rentalApiService.fetchMyGarageVehicles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
