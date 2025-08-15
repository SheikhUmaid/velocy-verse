import 'dart:io';

import 'package:dio/dio.dart';
import 'package:velocyverse/networking/apiservices.dart';
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

class RentalApiService {
  final ApiService _apiService;

  RentalApiService(this._apiService);

  Future<List<RentalModel>> fetchMyGarageVehicles() async {
    try {
      final response = await _apiService.getRequest('/rent/my-garage/');
      final data = response.data as List;
      return data.map((json) => RentalModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleAvailability(int vehicleId) async {
    try {
      final respone = await _apiService.postRequest(
        'rent/toggle-availability/$vehicleId/',
      );
      print("Availabilty changed!! ${respone.statusCode}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> accpetRentalRequest(int requestId) async {
    try {
      await _apiService.postRequest("rent/accept-rental-request/$requestId/");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> rejectRentalRequest(int requestId) async {
    try {
      await _apiService.postRequest("rent/reject-rental-request/$requestId/");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<VehiclesForRentModel>> fetchRentalVehicles() async {
    try {
      final response = await _apiService.getRequest(
        '/rent/car-rental-home-screen/',
      );
      final data = response.data as List;
      return data.map((json) => VehiclesForRentModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SentRentalRequestModel>> fetchSentRentalRequest() async {
    try {
      final response = await _apiService.getRequest(
        '/rent/sent-rental-requests/',
      );
      final data = response.data as List;
      return data.map((json) => SentRentalRequestModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReceivedRentalRequestsModel>> fetchReceivedRentalRequest() async {
    try {
      final response = await _apiService.getRequest(
        'rent/lessor-rental-requests/',
      );
      final data = response.data as List;
      return data
          .map((json) => ReceivedRentalRequestsModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<RentalVehicleDetailModel> fetchRentalVehicleDetails(
    int vehicleId,
  ) async {
    try {
      final response = await _apiService.getRequest(
        '/rent/rental-vehicle-details/$vehicleId/',
      );
      final data = response.data as Map<String, dynamic>;
      return RentalVehicleDetailModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<HandoverModel> fetchHanderOverForOwnerRequest(int requestId) async {
    try {
      final response = await _apiService.getRequest(
        "rent/car-handover-detials/$requestId/",
      );
      final data = response.data as Map<String, dynamic>;
      return HandoverModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<RiderHandoverModel> fetchHanderOverForRiderRequest(
    int requestId,
  ) async {
    try {
      final response = await _apiService.getRequest(
        "rent/handover-details/$requestId/",
      );
      final data = response.data as Map<String, dynamic>;
      return RiderHandoverModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ReceivedRentalRequestsRiderProfileModel>
  fetchRentalRequestRiderProfile(int requestId) async {
    try {
      final response = await _apiService.getRequest(
        '/rent/rental-rider-profile/$requestId/',
      );
      final data = response.data as Map<String, dynamic>;
      return ReceivedRentalRequestsRiderProfileModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<MyVehicleDetailsModel> fetchMyVehicleDetails(int vehicleId) async {
    try {
      final response = await _apiService.getRequest(
        '/rent/rented-vehicles-for-editing/$vehicleId/',
      );
      final data = response.data as Map<String, dynamic>;
      return MyVehicleDetailsModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<RentalVehicleOwnerInfoModel> fetchRentalVehicleOwnerInfo(
    int vehicleId,
  ) async {
    try {
      final response = await _apiService.getRequest(
        '/rent/lessor-documents/$vehicleId/',
      );
      final data = response.data as Map<String, dynamic>;
      return RentalVehicleOwnerInfoModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendRentVehicleRequest({
    required int vehicleId,
    required DateTime pickupDateTime,
    required DateTime dropoffDateTime,
    required File licenseDocument,
  }) async {
    try {
      final formData = FormData.fromMap({
        'pickup_datetime': pickupDateTime.toIso8601String(),
        'dropoff_datetime': dropoffDateTime.toIso8601String(),
        'license_document': await MultipartFile.fromFile(
          licenseDocument.path,
          filename: licenseDocument.path.split('/').last,
        ),
      });

      final response = await _apiService.postRequest(
        '/rent/rent-request/$vehicleId/',
        data: formData,
      );

      // Handle success if needed
      print('Request submitted: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        final message =
            errorData['message'] ?? errorData['error'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception("Error:");
      }
    }
  }

  Future<void> submitHandoverDetails({
    required int requestId,
    required bool handedOverCarKeys,
    required bool handedOverVehicleDocuments,
    required bool fuelTankFull,
  }) async {
    try {
      final formData = FormData.fromMap({
        'handed_over_car_keys': handedOverCarKeys,
        'handed_over_vehicle_documents': handedOverVehicleDocuments,
        'fuel_tank_full': fuelTankFull,
      });

      final response = await _apiService.postRequest(
        '/rent/vehicle-handover/$requestId/',
        data: formData,
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        final message =
            errorData['message'] ?? errorData['error'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception("Error:");
      }
    }
  }

  // Future<void> editMyVehicleDetailsRequest(
  //   int vehicleId,
  //   FormData formData,
  // ) async {
  //   try {
  //     final response = await _apiService.putRequest(
  //       '/rent/vehicles-details-edit/$vehicleId/',
  //       data: formData,
  //     );
  //     print("Edit data: $formData");
  //   } catch (e) {
  //     throw Exception("Error: $e");
  //   }
  // }
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
    try {
      final formData = FormData();

      // Text fields
      formData.fields.addAll([
        MapEntry('vehicle_name', vehicleName),
        MapEntry('vehicle_type', vehicleType),
        MapEntry('registration_number', registrationNumber),
        MapEntry('seating_capacity', seatCapacity.toString()),
        MapEntry('fuel_type', fuelType),
        MapEntry('transmission', transmission),
        MapEntry('security_deposite', securityDeposit),
        MapEntry('rental_price_per_hour', rentalPricePerHour),
        MapEntry(
          'available_from_date',
          availableFrom.toIso8601String().substring(0, 10),
        ),
        MapEntry(
          'available_to_date',
          availableTo.toIso8601String().substring(0, 10),
        ),
        MapEntry('pickup_location', pickupLocation),
        MapEntry('vehicle_color', vehicleColor),
        MapEntry('is_ac', isAc ? "true" : "false"),
        MapEntry('is_available', isAvailable ? "true" : "false"),
        MapEntry('bag_capacity', bagCapcity.toString()),
      ]);

      // Add new images if any
      if (vehicleImages != null) {
        for (final image in vehicleImages) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                image.path,
                filename: image.path.split('/').last,
              ),
            ),
          );
        }
      }

      // Add new document if any
      if (vehiclePaper != null) {
        formData.files.add(
          MapEntry(
            'vehicle_papers_document',
            await MultipartFile.fromFile(
              vehiclePaper.path,
              filename: vehiclePaper.path.split('/').last,
            ),
          ),
        );
      }

      // Add deleted images if any
      if (deletedImages != null) {
        for (final imageUrl in deletedImages) {
          formData.fields.add(MapEntry('deleted_images', imageUrl));
        }
      }

      final response = await _apiService.putRequest(
        '/rent/vehicles-details-edit/$vehicleId/',
        data: formData,
      );

      print('Vehicle updated: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        final message =
            errorData['message'] ?? errorData['error'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception("Error updating vehicle");
      }
    }
  }

  Future<void> deleteMyGarageVehicle(int vehicleId) async {
    try {
      await _apiService.deleteRequest("rent/delete-rented-vehicle/$vehicleId/");
      print("Vehicle Deleted");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> addNewVehicleForRental({
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
    try {
      final formData = FormData();

      // Text fields
      formData.fields.addAll([
        MapEntry('vehicle_name', vehicleName),
        MapEntry('vehicle_type', vehicleType),
        MapEntry('registration_number', registrationNumber),
        MapEntry('seating_capacity', seatCapacity.toString()),
        MapEntry('fuel_type', fuelType),
        MapEntry('transmission', transmission),
        MapEntry('security_deposite', securityDeposit),
        MapEntry('rental_price_per_hour', rentalPricePerHour),
        MapEntry(
          'available_from_date',
          availableFrom.toIso8601String().substring(0, 10),
        ),
        MapEntry(
          'available_to_date',
          availableTo.toIso8601String().substring(0, 10),
        ),
        MapEntry('pickup_location', pickupLocation),
        MapEntry('vehicle_color', vehicleColor),
        MapEntry('is_ac', isAc ? "true" : "false"),
        MapEntry('is_available', isAvailable ? "true" : "false"),
        MapEntry('bag_capacity', bagCapcity.toString()),
      ]);

      // File uploads
      for (int i = 0; i < vehicleImages.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              vehicleImages[i].path,
              filename: vehicleImages[i].path.split('/').last,
            ),
          ),
        );
      }

      formData.files.add(
        MapEntry(
          'vehicle_papers_document',
          await MultipartFile.fromFile(
            vehiclePaper.path,
            filename: vehiclePaper.path.split('/').last,
          ),
        ),
      );

      final response = await _apiService.postRequest(
        '/rent/add-your-vehicle/',
        data: formData,
      );

      print('Vehicle added: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        final message =
            errorData['message'] ?? errorData['error'] ?? 'Unknown error';
        throw Exception(message);
      } else {
        throw Exception("Error adding vehicle");
      }
    }
  }
}
