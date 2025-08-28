import 'dart:io';

import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:velocyverse/pages/user_app/rental/data/handover_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/my_vehicle_rental_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/received_rental_request_rider_profiel_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/received_rental_requests_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/rental_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/rental_vehicle_detail.dart';
import 'package:velocyverse/pages/user_app/rental/data/rental_vehicle_owner_info_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/rider_handover_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/sent_rental_request_model.dart';
import 'package:velocyverse/pages/user_app/rental/data/vehicles_for_rent_model.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';
=======
import 'package:VelocyTaxzz/pages/user_app/rental/data/handover_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/my_vehicle_rental_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/received_rental_request_rider_profiel_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/received_rental_requests_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/rental_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/rental_vehicle_detail.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/rental_vehicle_owner_info_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/rider_handover_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/sent_rental_request_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/data/vehicles_for_rent_model.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/rental_api_service/rental_api_service.dart';
>>>>>>> Stashed changes

class RentalProvider extends ChangeNotifier {
  final RentalApiService _rentalApiService;

  RentalProvider(this._rentalApiService);

  List<RentalModel> _vehicles = [];
  List<RentalModel> get vehicles => _vehicles;

  List<ReceivedRentalRequestsModel> _receivedRentalRequest = [];
  List<ReceivedRentalRequestsModel> get receivedRentalRequest =>
      _receivedRentalRequest;

  List<VehiclesForRentModel> _allVehicles = [];
  List<VehiclesForRentModel> get allVehicles => _allVehicles;

  List<SentRentalRequestModel> _sentRentalRequests = [];
  List<SentRentalRequestModel> get sentRentalRequests => _sentRentalRequests;

  RentalVehicleDetailModel? _vehicleDetail;
  RentalVehicleDetailModel? get vehicleDetail => _vehicleDetail;

  RentalVehicleOwnerInfoModel? _rentalVehicleOwnerInfo;
  RentalVehicleOwnerInfoModel? get rentalVehicleOwnerIfo =>
      _rentalVehicleOwnerInfo;

  MyVehicleDetailsModel? _myVehicleDetail;
  MyVehicleDetailsModel? get myVehicleDetail => _myVehicleDetail;

  ReceivedRentalRequestsRiderProfileModel? _receivedRentalRequestsRiderProfile;
  ReceivedRentalRequestsRiderProfileModel?
  get receivedRentalRequestsRiderProfile => _receivedRentalRequestsRiderProfile;

  HandoverModel? _handoverModel;
  HandoverModel? get handoverModel => _handoverModel;
  RiderHandoverModel? _riderHandoverModel;
  RiderHandoverModel? get riderHandoverModel => _riderHandoverModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _sendError;
  String? get sendError => _sendError;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String? _editError;
  String? get editError => _editError;

  bool _editSuccess = false;
  bool get editSuccess => _editSuccess;

  bool _isAdding = false;
  bool get isAdding => _isAdding;

  String? _addError;
  String? get addError => _addError;

  bool _addSuccess = false;
  bool get addSuccess => _addSuccess;

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

  Future<void> fetchReceivedVehilces() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _rentalApiService.fetchReceivedRentalRequest();
      _receivedRentalRequest = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMyVehicle(int vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _rentalApiService.deleteMyGarageVehicle(vehicleId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyVehicleDetails(int vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myVehicleDetail = await _rentalApiService.fetchMyVehicleDetails(
        vehicleId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReceivedRentalRiderProfile(int requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _receivedRentalRequestsRiderProfile = await _rentalApiService
          .fetchRentalRequestRiderProfile(requestId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHandoverOwnerDetails(int requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _handoverModel = await _rentalApiService.fetchHanderOverForOwnerRequest(
        requestId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHandoverRiderDetails(int requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _riderHandoverModel = await _rentalApiService
          .fetchHanderOverForRiderRequest(requestId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitHandoverDetails(
    int requestId,
    bool handedOverCarKeys,
    bool handedOverVehicleDocuments,
    bool fuelTankFull,
  ) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.submitHandoverDetails(
        requestId: requestId,
        handedOverCarKeys: handedOverCarKeys,
        handedOverVehicleDocuments: handedOverVehicleDocuments,
        fuelTankFull: fuelTankFull,
      );
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> fetchSentRentalRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sentRentalRequests = await _rentalApiService.fetchSentRentalRequest();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRentalVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allVehicles = await _rentalApiService.fetchRentalVehicles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VehiclesForRentModel> filteredVehicles(String type) {
    if (type == "All") return _allVehicles;
    return _allVehicles
        .where((v) => v.vehicleType?.toLowerCase() == type.toLowerCase())
        .toList();
  }

  Future<void> fetchVehicleDetail(int vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vehicleDetail = await _rentalApiService.fetchRentalVehicleDetails(
        vehicleId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRentalVehicleOwnerInfo(int vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rentalVehicleOwnerInfo = await _rentalApiService
          .fetchRentalVehicleOwnerInfo(vehicleId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAvailability(int vehicleId) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.toggleAvailability(vehicleId);
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> cancelRequest(int requestId) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.cancelRequest(requestId);
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> acceptRentalRequest(int requestId) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.accpetRentalRequest(requestId);
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> rejectRentalRequest(int requestId) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.rejectRentalRequest(requestId);
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> sendRentRequest({
    required int vehicleId,
    required DateTime pickupDateTime,
    required DateTime dropoffDateTime,
    required File licenseDocument,
  }) async {
    _isSending = true;
    _isSuccess = false;
    _sendError = null;
    notifyListeners();

    try {
      await _rentalApiService.sendRentVehicleRequest(
        vehicleId: vehicleId,
        pickupDateTime: pickupDateTime,
        dropoffDateTime: dropoffDateTime,
        licenseDocument: licenseDocument,
      );
      _isSuccess = true;
    } catch (e) {
      _sendError = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> editVehicle({
    required int vehicleId,
    required String vehicleName,
    required String vehicleType,
    required String registrationNumber,
    required int seatCapacity,
    required int bagCapcity,
    required String fuelType,
    required String transmission,
    required String securityDeposit,
    required String rentalPricePerHour,
    required DateTime availableFrom,
    required DateTime availableTo,
    required String pickupLocation,
    required String vehicleColor,
    required bool isAc,
    required bool isAvailable,
    List<File>? vehicleImages,
    File? vehiclePaper,
    List<String>? deletedImages,
  }) async {
    _isEditing = true;
    _editError = null;
    _editSuccess = false;
    notifyListeners();

    try {
      await _rentalApiService.editVehicle(
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        vehicleType: vehicleType,
        registrationNumber: registrationNumber,
        seatCapacity: seatCapacity,
        bagCapcity: bagCapcity,
        fuelType: fuelType,
        transmission: transmission,
        securityDeposit: securityDeposit,
        rentalPricePerHour: rentalPricePerHour,
        availableFrom: availableFrom,
        availableTo: availableTo,
        pickupLocation: pickupLocation,
        vehicleColor: vehicleColor,
        isAc: isAc,
        isAvailable: isAvailable,
        vehicleImages: vehicleImages,
        vehiclePaper: vehiclePaper,
        deletedImages: deletedImages,
      );
      _editSuccess = true;
    } catch (e) {
      _editError = e.toString();
    } finally {
      _isEditing = false;
      notifyListeners();
    }
  }

  // Future<void> editMyVehicleDetails(
  //   int vehicleId,
  //   String vehicleName,
  //   String vehicleType,
  //   String registrationNumber,
  //   int seatingCapacity,
  //   String fuelType,
  //   String transmission,
  //   String vehicleColor,
  //   String securityDeposit,
  //   String pickupLocation,
  //   int bagCapacity,
  //   bool isAc,
  //   String rentalPricePerHour,
  //   bool isAvailable,
  //   List<MultipartFile>? newImages,
  // ) async {
  //   _isEditing = true;
  //   _editError = null;
  //   _editSuccess = false;
  //   notifyListeners();

  //   try {
  //     final formData = FormData.fromMap({
  //       "vehicle_name": vehicleName,
  //       "vehicle_type": vehicleType,
  //       "registration_number": registrationNumber,
  //       "seating_capacity": seatingCapacity,
  //       "fuel_type": fuelType,
  //       "transmission": transmission,
  //       "vehicle_color": vehicleColor,
  //       "security_deposite": securityDeposit,
  //       "pickup_location": pickupLocation,
  //       "bag_capacity": bagCapacity,
  //       "is_ac": isAc,
  //       "rental_price_per_hour": rentalPricePerHour,
  //       "is_available": isAvailable,
  //       if (newImages != null && newImages.isNotEmpty) "images": newImages,
  //     });

  //     await _rentalApiService.editMyVehicleDetailsRequest(vehicleId, formData);

  //     _editSuccess = true;
  //   } catch (e) {
  //     _editError = e.toString();
  //   } finally {
  //     _isEditing = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> addVehicleForRental({
    required String vehicleName,
    required String vehicleType,
    required String registrationNumber,
    required int seatCapacity,
    required int bagCapcity,
    required String fuelType,
    required String transmission,
    required String securityDeposit,
    required String rentalPricePerHour,
    required DateTime availableFrom,
    required DateTime availableTo,
    required String pickupLocation,
    required String vehicleColor,
    required bool isAc,
    required bool isAvailable,
    required List<File> vehicleImages,
    required File vehiclePaper,
  }) async {
    _isAdding = true;
    _addError = null;
    _addSuccess = false;
    notifyListeners();

    try {
      await _rentalApiService.addNewVehicleForRental(
        vehicleName: vehicleName,
        vehicleType: vehicleType,
        registrationNumber: registrationNumber,
        seatCapacity: seatCapacity,
        bagCapcity: bagCapcity,
        fuelType: fuelType,
        transmission: transmission,
        securityDeposit: securityDeposit,
        rentalPricePerHour: rentalPricePerHour,
        availableFrom: availableFrom,
        availableTo: availableTo,
        pickupLocation: pickupLocation,
        vehicleColor: vehicleColor,
        isAc: isAc,
        isAvailable: isAvailable,
        vehicleImages: vehicleImages,
        vehiclePaper: vehiclePaper,
      );
      _addSuccess = true;
    } catch (e) {
      _addError = e.toString();
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }
}
